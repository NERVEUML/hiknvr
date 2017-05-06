#!/bin/bash
USER=admin
PASS=
C="curl --digest -u $USER:$PASS"
HOST="http://10.250.249.100/ISAPI/ContentMgmt/InputProxy/channels/"
NET="10.250.249.1"

makexml(){
	USER=$1
	PASS=$2
	CID=$3
	CIP=$4
	cat <<EOF
<InputProxyChannel>
	<id>$CID</id>
	<sourceInputPortDescriptor>
		<proxyProtocol>HIKVISION</proxyProtocol>
		<addressingFormatType>ipaddress</addressingFormatType>
		<ipAddress>$CIP</ipAddress>
		<managePortNo>8000</managePortNo>
		<srcInputPort>1</srcInputPort>
		<userName>$USER</userName>
		<password>$PASS</password>
	</sourceInputPortDescriptor>
</InputProxyChannel>
EOF
}
delcams(){
	for i in {1..32}; do
		CID=$i
		$C -X DELETE "${HOST}${CID}"
	done
}
addcams(){
	USER=$1
	PASS=$2
	for i in {1..32}; do
		CID=0 #$i
		CIP="$(printf '10.250.249.1%02d' $i)"
		XML=$(makexml "$USER" "$PASS" "$CID" "$CIP")
		$C -X POST --data-raw "$XML" "${HOST}" 
	done
}
delcams
addcams "$USER" "$PASS"

#DELETE deletes (natch)
#PUT modifies
#POST with id=0 adds a new channel
#/ISAPI/ContentMgmt/InputProxy/channels/$CID
#curl --basic 

#xml PUT (modification)
#<InputProxyChannel>
	#<id>$CID</id>
	#<sourceInputPortDescriptor>
		#<proxyProtocol>HIKVISION</proxyProtocol>
		#<addressingFormatType>ipaddress</addressingFormatType>
		#<ipAddress>$CIP</ipAddress>
		#<managePortNo>8000</managePortNo>
		#<srcInputPort>1</srcInputPort>
		#<userName>$USER</userName>
		#<password>$PASS</password>
		#<streamType>auto</streamType>
	#</sourceInputPortDescriptor>
#</InputProxyChannel>


