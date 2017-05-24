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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��%Y �][s���g~�u^��'�~���:�MQAAD�ԩwo����j��e2���=��/5�t�Mӫ{}k��n�t���+7^���)@
�4y��4�<�����(�#$��_��K����<�&[�i��e���i�r�����p�?������rz���x�}Ȉ�\�M�����k�MAe \,!p��x���7�T��%	���P�w��+���p��	�������?���:N�W���'i���_��k�?�xv���'=�(`� ����Z�{��X@P�<ʿ�I�y�;��q��Y��������O#��9��`���M����4��됄�{.�P������4E2�k;E�(����}�ث�s�!������?N���?^|��RC��?\�_��Y������.��km�:�AJ��&���ĻlR_�L~o�Q�k�VCٴ��MfBj��|����F_!X�b3h�q<u��ؤ������D�)�F=D!���t��S�N'[	��n C�T��>am�}yq �HqՏl���_�k߾A�Ɗ���k�������Eӥ��;���T�S�e���qu��:��xE���=��R��R�@��nȒ�j�V��2�4x���2BYS����ޖr<k.�m�h�ͅ�j2�u{�&�*Z�C�f	��5ļe���@�9��aRf�[7"��
��򸝢0i#��=də=Rg�A���?<Qd�a.�9�ĝh��&�or���s#w�p�W%W�׃�(f<�H����>-�������7Me'��k~�N��"r����;i�<��"o�5�H�X��`a�}� ď�������E�I>�{o-�+����g��x�P��GA� ����J��7�v}1ߍ$2%�F�4���5Vl�Z�:����6��Y�J.�\���+-5���Q��Δn�Z�lt�<����\��\�"Of�w�f��y4�P?ރ[ix⹰� ����"ב.�ˢ�N�rІobd��<�� �-��hӁ����H���Jy`2��E��#�ס��L�Il�@�0�"�l�Qs^?���߰����!���-���&���>d�b��F<g�x��r]�a���l���3����Ϧ���=�����������6����>�-�+�/��8+�߉��_j�a�l���j�����y·�܎��a���D�Џ�B�~Ĩo'T�CR���8(�X\L$�H+�앙{��H�?�������J�gF�D���d�{'ZL��%p�k�9jXC"ԗ������ۻ|��,�{��c��"�s1����V���( ͽ���K���2��]�թ� �����&́�l���9�zKӔ3#gh�ˋ,�?�|^ o�Jf��rB�=<�!�|-�t��������L^��B>J$��O��� ׁ��C�(��3�f&$���	I4��������5�/����&�f,O`@�Ϲ)��3��%��j���Ur(q��C�����%���o`�w��O��������g������E������������s�_��o�	�������2�K�������+U�O�����):�I#������8E��?�!h��Ew�e
���E� �h��H�����P��_��~�CT������vO��M
Zy8�XOP�Yǳ�>Wx�qpa��Q��Ë�?k�؂m�
f�dܐ����[&_z˖2�'�!rXm|�1�>��:ݎ,h��ܘ��%���_�[P�	v��lO�*��������?U�)�(�x�^��2P��U���_���.����?�����������r����=��f�GB��
Sz��Ђ���?�}0���C�f	����>�.to;M�w��q���G&]���dR�M��5�{&h�����Ρ"�1�+�0�C����ٰ�L�[��(�cД(�𸘠KnP�dՎ�cx�h]c��-���1"�H������ N4�Y8e�!9H϶�"�0y�J�^;w�	�)��P�&+����Q^p�ߙ�8>Z���ɠ	U��"�}�c�+~>4��~-&!oם�6;���gJ�Һ���r�c�����N�H�G2g)���:��9O�
�$+��V<�?�/��ό�!*�/"�ψ����T���W���k�Y����� ���т*�/������1����RP��������;����c[ A����+���ؤ�N?�0P>���v�����.�"K�$�"��"B�,J�$I�U���2�y�BI��W.��S��+��JU,o86'��t�lc�=GZu�-���=yA
/����w�<��i%���䎢�$���x5�`O@��嘱U��v���u{b"�4x6���MF��sJɩ�nV������z~��G�_���4Q����7��{�;O���U��].����eJ�r��]��R�^�?H��}Y9\.��J�e�#���vЋ口R��-����������O�����]��,F,�8�M��M��b��b������,����,��h�PTʐ���?�Y���������Aj�h�(��P�A����0�.���]#M���/���4���v]wW����s)���aDn5f����Q�5#���n��������j=qMP��	ff�^���9�_�����*����JO�?�����>�4�d_-T�L�!�W�?� ��V}�C)x-��}������?w�J���U�k,a	�0�������G��,	��3���s�=�J���.�j�u#}�F��;���@7�G�@CwA��h�A���vn�8P8��G`�t����t�v�#�|����mc�y[�ȵ�f��#<���39��&���k�͛#���L�-��%��f�f�����'�n��(F�|d���A7��:���6��9Z���x�����E�ք~ހNQe�6�xN�/ݩ�۝�ؐ�����^��.uF$��m�,O7|���0�v�X���M�i����o�)��足��Y�9ˌ������mo9�� ����N�ʹ��\��ފ��>�[Z��>\d��BiH�?/�#��K���a��xe�������������9�����[���j�?��I�du�{)x�������q`�~��[����NS!�����������䙡��7P���F���>���my�@M�wM��-���� �B$�vr��))�ci�J�hl�F�˶���[��SS�m�ߚ���&4�T6c��ij]�r�
��H��'}5i�v��@���q6��K����>@ k��#'P#�ڬ��]z�M��J̳F��K]��O�\;|�՞ق%w��Z�o�~�;�F�&����-T�}z�x�ϳ���#��K�A\n�#4Y�������'��T�J�g��j����2�������V���Z�������j�����]��\l�cV}�s9�\��[w�?F!T�Y
*������?�����z��S}�[)���	��i�P��"Y�eh��(�	�	� �]�}�pȀ�� �}�r]�q�N���P��_��~t�IW�?����?@i��-'�}˜�1lv�C���s�`�����GڢEM^��c�9��v�u%���Qt/YS\��A@����X�%5�Zߺ�#j��������pF�ehr��Lo�W�(�M{h^��y/�؝�i1��$���}���g�|�g���_�⾚�e`�Y���������O�S�ϾB��k#�K�6����Z��?]�^XL��vҩ{��_wuCW�5r�\ًdb�>�/��4^F�r}��V��I��e��7ͮ"~�����֫c;����$N���:�E#$����_��b�F���Z�&�+����:jG�kWE��q�"�.�ګO~r����sEsY=pr^�ʩ�6X|=�N�jWީ��b�����T��o}���^����Oo�vT�
׾��*
��
�#�i��W��m���VWD]�o�*�sӑ���A��~�r}�y���ڗ��h4�·�l_+*ɝ��sG�w�:��4̮o_��Yz���vy�Q�=Y��=����҂�?oA�%wۋ��M�7\G,��^d/���-�D��i�Žyx��}�!?��S������Okӻ]��o��yU������{,���-��JcK����<N��ex�Mӯ58N�p'�zg����d�\*��������'��Ё�Q"?Rg5�|j��G�>����?��,{����S�+��X�"��wu�oY廂x#�D~`����݁�=Z �˪����N7��dS)���ʪ�m����0<��5��S8�,�%u�=��O��b�S���=��{W�:Y��r���C	r9�e�p1�x��CE�n�v�n��7%מ�k�ukO�wb��L|	�7	!~ b������E��"h0ĈBL�h�m=��v���pA�s�{��������{����<�^l2�1F69_�)7�2�B�Y"� c���.������d&K]J�#�0�[۲vL@u�$uD���e8���V��i90���Xti1 ��f��O�9���mB�%�b¸�;�"�ʒ$�tpph|�m�5\����pr��5�!��L�nV)��8Z|ۀ��"&Y2b��h�n�ڨ�;VIp�><άW��w(IP�}F���H�t[��i��-���K��v��;ĻY�3n��2�`�g.��2{hJ#��U)�j�A�a�e����;��Cn��/��
��vI�Э����1�"���`��"yߢ�2@��S�(p�4��6�N}sp��/��������Ofw��h1�N�.�������U�*�z�̅��3���<'�Z����:��ӿ�e�M$�TҀő*�����#�é�e�猞N���"�9�eDi�ssW�kF���we>�W��k�ZS�*��n�9H3���E��ں��.2Y��<+e���)]����{�*wQ�h.P��Q�$
l����7��\sB�VWn�3Bs2��#���\���3�:�d4[PN�+�b��9���s�5D7r�I��6�sR�u�B��x���X��u��e���ۜ�i���i����Z;��O����\-VF�����l���ZT��ۅ�]��v�}�`�ՙ;pr*_ѫ��~8�4��F��QD��
���?�|@������V��q���?��Ps�?��ϻ��+q�(���8��������k-����6Ru�]W5�?$�Xdۋ��~?�ƶ�,�X�g�W���Q�U�G8�rzF9�I�{����~�3����[���x�7�/?��K���s�+x���n<AA?s�kƁp�N��;؍�C/޹�s�*��sз�AO�����������}z��}O��)���7�׳�y`D��{Q�K�Y�G�c=:��%�I��9a�\/L�A��-��mf�7
�t��D�T��F�Hn��m�K��bg�Y��D?C�ݜ�����C�+��f�v�r/��|i����;]P�d�8̣X���'�9��-F�%��G��~��݂�0I��F���a�]��=L��~����юp�S��,>^$����YB�tv�W2��TQp�	�T����|��R^�+`XNU[BLHz.%5XHh[%U�)�͇���K�)Nz��R��C�\ڏ�=}�f��LX�	�
z�@��K티�M=u��6��D�����!\�kO͕�u��`�ck�tM�F�xP�*�'����&�e���G�~ee�h.O�B��j�Z�;J��0�m����D�!��$3�0i$]N�L�D�ɰX��'�9d�#<#;V0��x'�	���*�!VI�����.֊�x���|�&��4/^�@�0J��t}�3�r�t3��ۉx��R4���z��ǘȾ�h���>&eY�댲l�3����r)���TJÁߝhpp��$_�h��p�h8��mi�+�|+�Zb�
��b+-_�ʕ�A4���)�Ht^+JT�RU@�4�c�x�%��e����Re��<�+�ѴoHZ��ѭ+r���N$*g=�x�q�T���Z�yw�
�n!A�JFj~$�d��^��t�b	��U�[e�-R��e��,��%��z<C!�V�ˣ$���@HP� ACwR��fn��ya����^jX@�J�(o��ډa�\e�nu����@@N��,a1Y�b��E�@YIo�I�ҙ2� sʲGxFv��0�M�;�a|o�Uk}Z(�L�Y�W��K9o6�s�>t��7���#�}��rmB��<��g(F�I�-G�A��I;f?eq�>����>�j>��)��iN\SPkm^ՠ�@�֮�6�5�����g��_��L0>�.@]���<�Й�<�WNW���ʡ�ڸ\dۜh���N��\�����%r78C���9(%K5n ��n�9�Wڸ$�Nn�	n"F1�4��՚�UC�֦������-��e
�C��IM�dK�	�5[��y�f��X��琳?�n�iu�Y���U��^?a�\ 7
`��j���-������*��6Kf|bZf���=w��E�Q�Ϝ�^����釞�6]�ŉ�j|<� 't p�I_�?9Fֿ�:�G���ס�֡���g��/+�<~��=Zx0i-<H�HB�g*]�$�V������-<(��:"m����`8;4�E�A�΃�"Xu��Ҟ'�8ꂃ�V�Әn֔A�{b��0c	>nzh��;CjSj�W����R��2�p���%�!ъ#��P� 9��
�"Bpd�)�Ѽ��&�tR�J�zq�и�T���*u<F�	�=�#A!m��11���!�GM���c���ajt����D�;X�Uo%���r$ӈu����|~g�P�T�~e�m)�(�l؃�`����o�ol�m�v|��ń`KT�H
Q��k�f��I��[g���K5��K�xx_�p��a�m���]/�n�6ݩ�eʹ<m�Cc�d:��gZ1byv�@w肷Ne�:me��y'��@˽����ct�����a�/��eG�>8��U��Tp�m�$Rn�*�d�u���92P�x�#���*��r���A|&(2����E&����t��,�?=�.�f�!��T��Rv�b�J�`$�����8��
 LxG�p0%�e�	 ^V�$�i����e�;}_N�RBńp�0�����B�Bw;�l��aB�Ɩ�|;����JQ�u%
�6��J]��3�W,�mwD�Q�~�+�*x�����0₳L��٨f�A��lɅ���;<���-	�s.�n�$���\���&qW�^"�}�v^�ò��6��7�8��㞍��䔹���X!��RHn�0��Ep���m6�jb�%d�j�kwT3Z��=�0%�>�h╊�k��v�~��k����BqI��[���S�(����; �R��=G5��?���	�
�ͽ,f׫���ͭ�w|�_��KO=������_��е�~ ��U���5��N�i�D�c��@�'�ݻ���\����	87�>���<Hw_z�������oz��7���'������'����Sq�8��[׮4�~�W&W�t��FӉjh:�F��W~�c�|��;���8=�x�7���=	�N��(���)j�N��Yj�6�Ӧv��N�&`�lj������H�i��iS;mj����>����yh��e�^8�r��%���,4�6y�m!t�����o=fb褏���!��<��5�E���n��3�?�ڟRm��m�q�g<�#p$���d��zmj��2O˞3cG[�93�� {Z�=g�6�8.Ü�#��=���13��q��Z[����G���y\�R�����v����d��m�/��8�  