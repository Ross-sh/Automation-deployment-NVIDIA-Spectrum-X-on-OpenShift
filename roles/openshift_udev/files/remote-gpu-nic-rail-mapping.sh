#!/bin/bash 
##############################################################################################################
# This script maps GPU/NIC/SLOT for ensuring only one Spectrum-X rail is assigned per GPU on same PCI Switch #
##############################################################################################################

# How to use the script if user does not know how
howto(){
  echo "Usage: remote-gpu-nic-rail-mapping.sh -g <gpu-device-id> -n <nic-device-id> -u <udev-rule-file> -r <openshift node role> -c <nodename>"
  echo "Example H200: remote-gpu-nic-rail-mapping.sh -g 10de:2335 -n 15b3:a2dc -u 70-persistent-net.rules -r worker -c dell-h200-2"
  echo "Example AMD-MI325X: remote-gpu-nic-rail-mapping.sh -g 1002:74a5 -n 1dd8:1002|15b3:1021 -u 70-persistent-net.rules -r worker -c amd-mi325-1"
}

# Getopts setup for variables to pass from options
while getopts g:n:u:r:c:h option
do
case "${option}"
in
g) gpuid=${OPTARG};;
n) nicid=${OPTARG};;
u) udevfile=${OPTARG};;
r) ocprole=${OPTARG};;
c) nodename=${OPTARG};;
h) howto; exit 0;;
\?) howto; exit 1;;
esac
done

# Make sure the variables are populated with values otherwise show howto
if ([ -z "$gpuid" ] || [ -z "$nicid" ] || [ -z "$udevfile" ] || [ -z "$ocprole" ] || [ -z "$nodename" ]) then
   howto
   exit 1
fi

# Set table header format 
divider===============================================
divider=$divider$divider$divider
header="\n %-12s %12s %10s %20s %11s %10s %10s\n"
format=" %-12s %8s %19s %10s %10s %18s %12s %12s\n"
width=100

# Slurp in the GPU devices based on gpuid passed
mapfile -t my_gpus < <(oc debug -q node/$nodename -- chroot /host lspci -nn|grep $gpuid)

# Slurp in the NIC devices based on nicid passed
# Fixup option for nic if multiple device ids passed
nicid=`echo $nicid |sed 's/,/\|/g'`
mapfile -t my_nics < <(oc debug -q node/$nodename -- chroot /host lspci -n|grep -E $nicid)

# Grab Dmidecode details for processing
dmidecode=`oc debug -q node/$nodename -- chroot /host dmidecode -t slot`

# Remove old udev rule file and touch new empty one based on udevfile option
if [ -f $udevfile ]; then
    rm $udevfile
fi
touch $udevfile

# This is where it gets real and all the logic happens
# Print table header for console output
printf "$header" "GPU BusAddr" "NIC BusAddr" "PCIe Switch" "NIC Slot" "NIC Port" "UDEV Eth" "UDEV IB"
printf "%$width.${width}s\n" "$divider"

railcount=0
seccount=0
for (( gpu=0; gpu<${#my_gpus[@]}; gpu++ ))
do
    gpubusid=`echo ${my_gpus[$gpu]} | awk '{print $1}'` 
    gpupcisw=`oc debug -q node/$nodename -- chroot /host lspci -d $gpuid -PP | grep $gpubusid | awk -F '/' {'print $1"/"$2'}`
    railflag=0
    for (( nic=0; nic<${#my_nics[@]}; nic++ ))
    do
       
       nicbusid=`echo ${my_nics[$nic]} | awk '{print $1}'`
       nicid=`echo ${my_nics[$nic]} | awk '{print $3}'`
       nicpcisw=`oc debug -q node/$nodename -- chroot /host lspci -d $nicid -PP | grep $nicbusid | awk -F '/' {'print $1"/"$2'}`
       if [ "$nicpcisw" = "$gpupcisw" ]; then
           if [[ "$nicbusid" == *.1 ]]; then
               nicport=2
               altnicbusid=`echo $nicbusid | sed 's/.$/0/'`
               nicslot=`echo "${dmidecode}"| grep -B4 $altnicbusid|grep ID|awk -F ': ' {'print $2'}`
               if [ "$nicslot" = "" ]; then
                   nicslot="NA"
               fi
           else
               nicport=1
               nicslot=`echo "${dmidecode}"| grep -B4 $nicbusid|grep ID|awk -F ': ' {'print $2'}`
               if [ "$nicslot" = "" ]; then
                   nicslot="NA"
               fi
           fi
           if [ "$railflag" -eq "0" ]; then
               etudevname="eth_rail$railcount"
               ibudevname="roce_rail$railcount"
               railcount=$((railcount+1))
               railflag=$((railflag+1))
           else
               etudevname="eth_sec$seccount"
               ibudevname="roce_sec$seccount"
               seccount=$((seccount+1))
           fi
           # Display to console the details
           printf "$format" $gpubusid $nicbusid $nicpcisw $nicslot $nicport $etudevname $ibudevname 
           # Write the rail details to udev file
           echo "ACTION==\"add\", KERNELS==\"0000:$nicbusid\", SUBSYSTEM==\"net\", NAME=\"$etudevname\"" >>$udevfile
           echo "ACTION==\"add\", KERNELS==\"0000:$nicbusid\", SUBSYSTEM==\"infiniband\", PROGRAM=\"rdma_rename %k NAME_FIXED $ibudevname\"">>$udevfile
       fi
    done
done

 Take udev file and generate machineconfig for OpenShift
udev_rules=`cat $udevfile|base64 -w 0`
#cat <<EOF > 99-machine-config-udev-network.yaml
#apiVersion: machineconfiguration.openshift.io/v1
#kind: MachineConfig
#metadata:
#   labels:
#     machineconfiguration.openshift.io/role: $ocprole
#   name: 99-machine-config-udev-network
#spec:
#   config:
#     ignition:
#       version: 3.2.0
#     storage:
#       files:
#       - contents:
#           source: data:text/plain;charset=utf-8;base64,$udev_rules
#         filesystem: root
#         mode: 420
#         path: /etc/udev/rules.d/70-persistent-net.rules
#EOF
#echo "Generated 99-machine-config-udev-network.yaml file for OpenShift"
exit 0
