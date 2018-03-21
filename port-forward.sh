#!/bin/sh

host_port="80"
guest_port="8000"
guest_ip="127.0.0.1"

while [ "$1" != "" ]; do
    case $1 in
        -hp | --host-port )     shift
                                host_port=$1
                                ;;
        -gip | --guest-ip )     shift
                                guest_ip=$1
                                ;;
        -gp | --guest-port )    shift
                                guest_port=$1
                                ;;
        -d | --destroy )        shift
                                destroy=true
                                ;;

#        -h | --help )           usage
#                                exit
#                                ;;
#        * )                     usage
#                                exit 1
    esac
    shift
done

# Destroy forwarding
if [[ $destroy ]]; then
    sudo pfctl -F all -f /etc/pf.conf
    exit
fi


echo "Host port: ${host_port}"
echo "Guest IP: ${guest_ip}"
echo "Guest port: ${guest_port}"

# Set forwarding
echo "rdr pass inet proto tcp from any to any port ${host_port} -> ${guest_ip} port ${guest_port}" | sudo pfctl -ef -
