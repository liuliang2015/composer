(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��%Y �[o�0�yx᥀�P�eb������֧($.x�&�Ҳ��}v� !a]�j�$�$r9�o���c����xa���sk��t�v�.a��E�Q^v�U
�\��C)�D�E ���JqtZ���?%E$/��E�,B$�6��3 <�-���6{ {�
I`�q��B��`-	��9��u��v���m	͐���lt�8z��&h\�ˎ�.�̆�����Dyr#k�����٧?yڿQ�a/&	�d�m=�w�\�Ԟ��C�ț��,Z�(�f��f�(�Df�ҁ���L�5�?j����:�y`ֺ.&4Ù:����OR��N-�&��v��܊�8HQG��td*�BVzC�f>���xأɫp�>�M�V`���*�jxBo�U��6B�smlܗ��J���B��(6K�;��WM6z����ӵoI�42���M�!
ݖ��h�6hD.B!��X�?p`�L��i�&��VU<�DEw�49�߿�е�+$�S����J�ҨZ`>OG��h��:��:��@�ގG��s �c�@�|�1=nf$x�.��RAA5k�e��<��[�����X��&8d�`»Cb�m6�t����T����ܠ��r�8 ���<��s��ϸM�C��-7*O�����k
�nEB��ࣆ/O�z�8�s� *kQJ�K��z�*m�l�X86p�b�i�AQA�{{>/�=��7�r<��kB�����1t맿zvx�������p8���p8���p8����M~BVܥ (  