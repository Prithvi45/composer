ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

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

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.12.0
docker tag hyperledger/composer-playground:0.12.0 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

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

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �Y �=�r�r���d��&)W*�}�r&;㝑DR�dy����ZcK�.�Ǟ����D�"4�H�]:�O8U���F�!���@^��Ւ/c[���~�%��� ���Xk!;��v;(�1a�ac�������a@ ���4.	��)DeI|"FEE��h,"���}��-x�m ��6��b����J��l���&x.=�8�]CC�&�脽I>�o�٧l���S��h�)k�;�6��@vd�|B�jۮ� �o�&��!�k��j#�"��
�{�L�4�W��s��� ��Oxں�o�w���m�B�����`X�}��G�V��a�##�ƦI���P��4��bq�zPɤ��F*!ּ�(�6"0�TZ2}܅��>̧�5����ڷq�0����i�a�6�뚯#G���M�l��dYe���u\R%���Cl��!4+.�~���h�ё�H����dh:��5�{t���p�ud��q��舖g�T���6#��r��v�D��qA;��b�����V�����E��j;�|��ٳb���v�3���M���k0�	����7��P?��_�ul��_}����w'��R��:u�D]�̷��dݹ�C�0�M`y�yo0�8�,����bS����3����ȶ�9�V���� �����w�!uCt�'�yp4ȋǕE��a�'L����<�$s���挿�H�{�?����}y��W��(It��(� I����R|�/�~�V��&�`����� ����M�$�|�T+ۧ���r*�N�0��:~�tz:�951$Q�/́��a��Sۧ��Y�_\���+���a��w�ւ>s�� <����p�O��ڿSD!J�	Ř���@W��U�Ue`�F>�$�(BX+~��~2;�V� ڳ.X�O��&�.2q���qAǳ�r,�۱�.t�h��!Vd#��p��m��u��r'W�YŒ'M�FW���{�.Ʀ���`%�C�mb{v�)���3Y��i��l@�$���K}~��Pʚ���ք��:���G;ԡ�|���,����w9���}g�5�0�����e�|�3; ���^�Z�ľǭ%����(�?DÉ�p�����Hˣ}7���Ib�ɰ�f�On��2>\��SM3���7�!��蚟�I㱨B��$��j��������Fy��Yl�M肖a� Z:�Qw)D��,˰�B7�丸�b���}q�����8 �q�3���&�EA~�x|xMIZ� ���C�Qڐ��ʇ��'!
	6LNF����4�Nr�r/�F�߆��� �)�����d���d��!Bb�c>
��������v��~��6����d>���m~�� ��yaa���7�SΏ�|@U!�3�A�2��C&�7@��OcN>��ҧ�+҇��E	��g���]��c�m���q��Jt��7tp��4�����E6�'�s�Gg�SN�`������}�Sf�:�[�����LN���U����_�2Xg�����`���1����5��V`�<tn�A9r����B��K�9�?U����p����W��2`���e��������H_���?&�J4*Q����/�8)=އ�3o��ѐHϜ�h8fc��h���a��<ۦ�� ���\:_��w�U���J��߯n���&T�?�]9X<v9�<xNEb�r�D�Y5YΧN3�J~���|0���w
�,��H��xm���"��4sLW�
R�8d:h1MB�.�?�~D��+���V�j�zZ�2{��RO�͓]T���ҝ�+M���%*~h\h���x'�^>cYyD����w��\�[�l>| �%	.��	�$����5d����,,"�K�䆆�v�BЭDɈ��H����?����"�˙�����\4\�i|����Id�X����*���a����C. o���(̮�Ⲱ��e���?��S���V���i�P�c��q��8!<0��W^��0��g���{�g\�	���e����V8�҂��0���I�U��R������_$ :�DD�H��*��������]�c���m�ȶ��
tl�r���6�t'��xu���	�![iz.{��h_}+I����︨h���1
�E}�+��t	=��?&�
��E��xEib�4��E�S�Bv�i���d�lؚ:�-{y|�%��#�,�a����a����+dj��kd�wLb�a��ph&��*��"���>I�7��q1:3�G����_
�r��������;X�RD�d��7��sÔZ{2�3�jz�q�|#v�CbX�7U����5du�T#8�{7.�Ӛzm��'��m��>I7�?1�����@�_Rdye�ˀG����,K�m4�.���0����[ǄWp"s?j��P����B7���b3�?9�:�����?���.�'�>��>���p��� �^w&��:�Z0q��nqA���*�u�x�@.�Da����0n������F<��2{Y��-{m����f��L^�2�^�K��_��M���"��M!����rLՑ�W`�B���n��s����@s�˘�>{CƼ�0�*L\�1�ԙ�c�]n�2�k����ҔE�L\.�G��Q� Kf�ѥ���&tȄ��@#�юʢ[�Ռ��/(=�7�����x�}�_�G����2���?vb�{
��7�|��_A�K3�(�������}͝r�����}�?�����W����??���5A�e)�Q�DM��^���F"���,�!�E$��D-�5('�DB��7���(k��5�篹Y�k�ڿr�v:�A���qk�pI���'�=��l���^����ֆ3ظ����j��_M�����jL��߱Y��o�b�~��d����#�p����ڷ�oF�8eD�&p��!Ώ������Gއ��?�p����_"e�$������2��t��mx������/�m���_\k��[C�R��I�h�1�z��$}��:Y?п��'O��g:]�o^�Ѡ�qy��q�Eek��juA�oD���F�5���%d)����С�EeA��F&jb��e%NX#j����[��Y�6'D!��� �)W��|J�fX�{��ϧrg����j/�T��Z�����˾I���m����Y���|��82��]dv	��SŃL�YH�3j9�(R�T�ج��v-�ƃG���z�?Ӫ�C��H��[Z;�K�ű�q���o}\������w�٬�M:'�&	��i�8�jF*6�[�������V,T�^�,/�ya����h�+�eﭣ�d�Prz��q��T�ezo.2��8ںT��S��<:�jm�s\��%����{�@�z��I��H9�o�g��L��������.<RT�V���(�u�ܹ��.vk��	��d!���U
rBmdr�T��V����y;�ɒ�k�W��C�ۍ��;Gg�K�~8*W�$�����a�,ԏᎺ��z�0�B�$~��7��x�)���؉������j5�[Pe2DZ=��$#���FZ-о�.�j}#���j!��V��^�UH���d�>�^<�O&�[vy���i촉��ޞ-����!�Q���{�ZFF0�
��9H�K)��)��[�L�c�z��x�P���u�2��+�b�ݔi�e'���7}gq�3�^!�*ﭷ���}(����w��AY�zo1���s̀�H8��.����z$3���\?�_���Q, �bL�=��$�����{�M������}}w�^��۾�%�������g�E�X�ˀ�8i��?$�����o�B>�M�d��9:�z��P�RC����6"	�U�}˝쩇BE|���#���4�.�;%K�$�J�j��A��)�.�0yq(�S&~YC�o9��u�/����5�rp�-�F�yd`�U�$$AM����nz�*�6J������|W��{�����_�:�+�����������'���_�3�+���������ͧ&��l���o�)�4�
I�%-]j��ٙl� V�o
�G/��M����o9��=�Z�y哷�a��hb��Î���ۺp-�m��=q�1z�Bb�c5�y�V[[���d���~;�	��︘&�ԍF�o�+a7�,.K3���L����?><)���,{2�,�ov'T�eZ�2bz����4s?�6��_{��r��7���[�GC���g ���!�Fu�2X��Ӭ.hlC�mh���$�Z��	��iB�{2K��<�(�_�s  ��а6�D~+hޔ"_� ��b!@_;�^5d�KA���D.L?�4L���mc��(Н�W�a{o��4��QTx(�c�oC|T�e�ǚ;�����h�,�dK�h�&��ht�,�`����s��`���&T�f&�tV�Ǟ��'j�fz�@p�����=�؃�K��*"�]�ʷF�B@�5�������!-$r���B;C�qY��v*Au{����{{:cq �(���A���d�O��FQ�W�����J=<A'E�[�n��c.��L:A��ܠy�B�Qb�؆����Z7U$�K��?)��c���T�]��ex��� L���<��	���?��.4=�����L��iz�j%bB�W�FN�*Z��������:Ƥ�h��b�OJ���M�q�+�)�2�M���X��Y1dK�"�E��\�j�^P~�x�eh���_Hh�{����D����6
\	;Z��a��CӨY��2Ń#_���k�����o:����Ia�rC�P펱G&���.���MqTB6����+� 8����|m����������#������5����>}j*/�c��2�"&�=��H��i��K�۞��!NE3=�X��v�F���f@/p��M֔;l4lԠ���1�\CSy�ģ�UH�P�|{ƈ^æi��pIs�S>�ö����[7��M��
�&C��>��g0 �t��1���G3���-�X�>�Ni(�[�4���d6���,�*˱y$����k�qK��3MS���&w����m�uq�����+�;�Sq�ΓEɉ���Q�'Y��!�@K �7�vĤ-`3!z�X�@����G�G=nս��:��u���>�����p7�M���]uhkh�	breW��q2�m�i"r���%!��#�/��Y������_��ǽ�)���������7���_B��#����qd��������ͣA��[�F6�I�)�~FґXDQeL&#J���8�E�hK��q��h���q�l�	J�b
NTG��	%b�B���Ї�����[?��������tn忠~��ơ����a���B��>��
Ek�����������{��������� ��X.���A���z����o�ݛ��v���+��:��bE.���b�ʱ�g�i�2�+�1�l�{����"ǜ�K��Bn���UH ]�ٶS�'w����Ȏ�\�?EvgdԤ��sK��s�H��M�~�p��g���%�qh�ѫ�X-���[c�Q������5�{b�a%�.�[�d�얆�^k����L,���3��s�{�T�F�Z�ʴA�M�dY�.��!�<w�(S�3���	�n�\��7���if���E͢ߤLK�h��S|i�zB�놮�L2�)�J��~�-��ܬ�_X35U��vF�'�:b�8��V`�i�e��"����=?"�H!l��X�3KN�� �ْC�Y��n���M�"j��4a�S���/H3CY�IϊB}��6��No|Anb��]e������+�&ې��h"�xL���Z�BO��c2a(m��<�N�	!U����g�r�,1�a���[�����ɩ0V%)v�X�(����-vy���r�]���]���]���]���]q��]a��]Q��]A��]1��]!��]��.�������QN3D�M�3�p-��9�v�}����^���K��嚘^J�j�������XSR�%t�]T��ƭUt��TO�J� @���&�J�N� ����:�=b�T43��Y"{��sS�6kR�}��gIa�����R��F�@0�&�d�"�͒�+�B}���5�;T��^� ��y�m���q������+|n���	C'�y�9_Zx;���/�K�O�I��xG�|2N�������7�
g%��Z7�-�����T?!0�l��qz.�'T>�?�jt�Y�O�D�:���w:��,F�+�̿���������C��Bo��~�赇o��[����V7�n^»7v���ϐ��-���ۛ��H�ڋ�'����:�����͇��kP���^<�yܡБݗ7B_��w�b�?� �>
}��п~	|�
�����5���A�B�������,��E�"�t�`�fy���[[��h�N+���Η���S�t~������t�[`y(���X͢�<=Ʌ��jJ.�]E�ﺢ�27%p]d+����P`��$Fb�mWY�Jq�,k<f1���t�]��ttJ'��17.���"�dmv��x.?��V#}��BS;��i&1h�mc���y�d�X������&�3������)�:�e��I$�^N��6x�;�1��=�J�iTL@ZP�nQc����eЮ�T:��D�85���@��H�G�#4�K�YS��\��X����.��z��K��`P�1I�G�~=o[]�j�EcЯXm�6B�b+��1��up��������0[�3$�D��NB�׿�x��2M�-�P.62� TEq���l��N{����p�_Y����M9�d����r=O?">W�d�����5�s~�����>��	�3�fU������m��cw���L��m�%���>-�n��r��,���jɂ9��z![ )C��M�8��\=�״be�֖�>G"l)��M�4h�q{suQ
�0�%��h3����E.'���2"c9�2��	�a�S�Y��D�FL�6��Ԩ[,�B7��Ϻzgz��.N�=���"[���D*#n��]a�(�Q���뱂�jV�L�֗*ʘϔ���F:�5�/�"���J��0]N"c�t��O�5��2��pa�|9����)Q�F�̲���l⿼�'rP$��"s�Aq<�kѩ��٬ғ#�Ub���*���b\E2Oz�����FLYP� �=��	����T&���I	��BA�{��J93�+��ib|l�z��#�T����Oa�1�0�N��͚Ų�%��4�e���9�b�,���JeT��"�26�iHlٛ �r[��xe�B�V��"r�/�KKV�1����M��s����	җI1-mH^_��D/��c,�%3T�5��R�1M�����3 �NP*>*�;LV��2k��l*Z���s��Ě<ʑ�Bj6۵x9��y�*f�����.��зm�a�.}'�v�t���x�2���|�B����-��9ќ�b�#/��_D~��CcjH��z7�&�1�G~�G�O����z/����g���=�y����H����;�7��+��"�`�7���k��C�.^ n�M�Z��<}������ѻ#��� ���+2�q>F~���M�-P��8�8uG�k�o���]wqE����!*����>?�C�^��E�eV��ל��.��� �Ȝ���5��0:����<|��Oz9�_��>z�	���Gݿ�9��Q���5����΀ ��V��|%ܳ3����#�E�)�*���<PM�Tv�����Uo��f_���'0���ϕ�)�3��U?��vW@��wO�o8Ua�e�ѥ�e�p?]���o�Y׋llݮ��V] �_��bNvt�dG�~���Sx{��;�����@�N���ӸD�:�"�=,�a�1
@>:�A�)���t?Qa��� �3���{PїA������a���&ö�� �1^0�{�$̰�Mu%<Tm��]n}�~e��Wkjz2 ��l>_�� �jd�0	 ��x�xK|v�'�]����s"�����!P���o���A��h��p�MFC�_f�:�M����`�`?yE��Wag
Va��i�
E�.d,�=wh��m�od�v�ʜ�N�k��Б��1�k�`�l�;���ɸ�ы�'�� �aa���X�O¥�]�ȋ,_BV���_�����	?3 �L�Xݜ�M��ͧ�u�y�����h�lH؏���V������ůG~�����&x�d22��k�������Е��� �N�
��`iA�덺<��]p���7�a@��0�:7�js�'p��yC�F I	|�<��'$!�[]�V׸8sxF �n�e��ö}<4d��h+[�0(i�+YU��֕��r��c)���W���p�����:��*�Rٻ}Q��z&k�s�.� ��s�G���/w��;u�pZ Y���-���/�x{݅�a���< (O(t�Ǡ����8����*T�@YXO�,�$L뵃�`g�����z`wF���A΀$ xU9�cM����bf�\L������=���
7y��恐�`kL˞穭�A��´'ٙ+��v�-�x�Y�:(��W'����RV]\u��JĹM�-��ca��� �/p�e�{c���_������6m��q��@�v�n��n��4���*Y�Sl5�`WB�D�ԝ�S�''���ɨԃ�a]3 ]�<��8� f�Y]W�F��\^�O :,N`����\�M��6�4ND�` ��I�+I���F^G����- 	���JS:@��[������k3U�M���X��_�p�P=�U �~�Ap��x׎�e-vp�7\�}��<���vL�k۸��?��l��&�_����C����A 	hm�*�sÑ�0���Mb��܁��u�aKB�,����OQ�l�;�s�rG�2_��%�[�����[䣫J��gI!{��W������O��5���kG&E�D(�E�r���	U�"j���t��V;���L�"��qBiuZ�8-�dL�	Z>3��$z/p�����Y���`>�Y�?n�?��c��O��� !7Ŏ�'̩��.��J<.�hJn�Zâ����J�19.�2M�q5����[
�!!G왌�U2��2-��Ą�� @'���
?V>��1�����'�so��2zr�ѸK�F1;s.���b;㮍���;2^ò;�^ʷ�Ǘl�N�9��dϲ�T���٧�ښv/�&�%>�p\�/��bо�.��-e���y�)<�&�n����/��vŠLV,�i���� ��V��;�'+�
���=ٙ�g���D�#p���6���޴�i{�ֹ�sQ�������9�l����ԛ��l�yp��Bw"���V7g�n}��n���8�r�ߎz)�'�%PyJȥ�
<_ڠt�>�f�\"ϭr:L��l%���*��9��r���P���(
�Z�3y�N�C׼zb	����$y�R0��n�L'<]���O��E������B�,�K�|�T�G��㣳���F�x�9���d?uj/0Rz�i@�}nY-ϥ�e��x�'�H˔��	�c�ȟ�Wi�u����M�L����ʡ��_��'��ك�&�vd�P/�a|}�@�1w�2����d�����7�}�x�Ml�Yc�o�.te�[��W�vE�C�8[}�y��sIH#�:v�k7���fg��KpE�;�ǞUJY����y�:P�q���ͷ�w��v�80`�w��/���$�Ӈ�/�Hw\�m���M���Ӷ�#���Gz��%�o�������#���)|��7v��������ԍ�|�������������#����*��6�?%�i_������}O�W6�K�_����ȶ�?��K:x�9x�9x�y�h�+���#�����Kڗ��*q��vT,�u�1�e�cJ��ڪ"����V��D�*iEɘ��'	�}f�,��j�Wa���m���k/)`�m��|��V縮Mm8�+�4}�W����&.t�i>Rhja^���SM�"zAwJ|�D;|�1����JdM���J��i-V���FG.�fD^6��~�tR�4�'�ji��Ӊj������1�s�������_~z�������˗�0��yH��>��6��x�p����*��q�9��}�}��K���=��|:�������u�GE����t�����{
��� ����忽�[�?�/����&. N����� ��]�S������Ւ�Џ�g����wm͉�]��_��[5r>\�U'ܼ��'PT�_�i��i�I:݁g:{]YN&iEk���z�CU��O�4���?	�?� �ꄣ:����O	�G<�����J���}(�k���[�!������E@��a?��P�3���'I@�_^���[�m��*ݠ��y�qXw�N��K����?�Z�?CCJ_�?���'�3����0�c�{�����o��(��'�*�z~�����'��H��J
�Z��Իi3���^3W=�P8�i��Dy0��d�|�V�k����*�e�e�lbW����e�?�,���>_�>���l�����ոCԣ#����L�Hi�di��қnW�E���v�S��͵�<HS_��v�5S6����qF��,T���;Ʋ֞�C�a���vC����S�N�|X�u-���?����f ����_�O�`���?��C����_��H��H���H8��@��?A��?�[�?�$�*���˓������[�!��ϟ���?�_����?�������ë��ε����ΙtN�� �YR׭u2`��������W�����/e}�GC���{��?t܌k�Ӏ<k�:χ�ڈw���7���>���GuY�˄b�鍂�i��\

��u���O�}����Y�4������Z�G�!Ou��� �X��%�R��BKſ��>�[����-m!�tBvJ�)�wN��%���F��beL��dR��lkx��D�;g�-��IK҈�^1�F��6�L����m̩�_���	�G<��*���[E����#(�k ���[�����w����/��W��6.�3�,�Yb��L@��B���|R,�\HRA�S!2�@x��?��Q�?����W���e�ӗ�DJ�V�d�<��Ӿ��Fԩ�,[�dm�K����3{{���S�.�#�Tݽ�ّ��66]���jrX�p�.6[J�=��y�&������� k�L�>�ó��:���V�p�����P������o�@���_}@��a��6 �����kX���	��C�W~e�w4-�9�j��\lcGo8g�L`�Uo��ۥ�-CƎ���R��=���#94�7/9�2�������慝��|�h|��8��S��#�qYRg~l8�xS�EƖ*�:�t����@��O��[������w|o�@a�����������?����@�$����?��W^�^y�1�-�Ӈ�,��q3�zg�P�<����-k��/��K�k;̱��Z�� �ӓ?q �g=����Tۣu�*U�v��g ��i��CW���!��2ݒ+|���ؠ�jJz��z��Ҷ�a[.C���Q��'�:kp���e/����7k���v�����b�z����p��{z��� �mI�!]끽�-�*>1q����/v�q<���i$)O��}7��k<oN����M��sC��7,kaH�����D+_jRƤ��ܟ4��jɚ:�q}�ZM~v얡ԘN���$ӹ���X��w����~OL�e$4#;�;�b��a�z|�c��ϒI4Ǘ���ws�E�A?�4�*����Ї	tQ�������<��0���@��I�A���+A%��~Ȣ*�������P�< ���!�����"`��&T���X�� �y���3������Y�"�Y>��`v;§Hr��E���,v~P���������r����U�e.3�,<�Ę$ G#Q>+fA/�݈.YӠS������C%�d�:��vI/�t��=����F1ĶJ�gɦ�O�8�.��f|����k�S����1\�z�,�^���qjӂ�߷��?A?8���J����x��U�U\�w��,E��_���������P���M�(���n�'�;���*B��/����AU������_x5�����o��汿��ˬ)�/�KRu����ò��oE�_�U�\`?3�}{����[+����[���3��N��a��~���~�,��:ێ1J{'Μ$S}�d����C�+u���xĭ��|����gv�0�q^V(�isZn�C֣�K;.���H=C��ح��<g�߮m'V�0�-m���$M����*��.��Q�����[���]�C���~*;Օ5K�s�b1Y�w�3�h�/f,4[��)�۱[���<k�Zl3:�n��e��R5�U�0�hc����xr�i�;�Lw("=�]P�W���քj���*������'	
�_kB���������7�� �a��a�����>N��9X H��ϭ�P���ׇ����!� � ���A�/�@�_ ��!�����?���A�U������/��u�������������$�����������m�n �����p�w]���!�f �����ă���� ��p���_;�3����J��C8Dը��4�����J ��� ���������a��" ��`3�F@�������� �W���Bj 
�����*�?@��?@���A�դ� �F@�������ڀ�C8D�@����@C�C%����������� �� ���$���� ����H���g���W����+
�?����������W��?$��@���� �o]�C�����P�n���S�}������Uxı�9���9/D��P�I*���g>R4���B@p�/�4�p��?�����X�����0�F�
�?�:}��۝k�)�S*��¿y��V�z��&M!Y,���n��l���Ӻ�Da9ԭ-y\ES���$�k3�]�-_�����D1F�V��2���w�!�I,/�[7M�N��H?��{�����G�H2�!+��^T�o8b@���������a]�Z���������Om@������2��7�����>���oRsn�N�jl�;4z�H�,�rؾ��-bp>\�L��_�?'Z죽6�&�o8�~��f���X����c�kqt&�-m�t�G)���b����n�3�A�"�fT�����v9X��	��[������w�+����#������(���W}��/����/����_��h�:����~�����>���S�_�����鈒����+_�x)���\���_�����M�)�'ym"V�u ���?*��U�͆rZ	;��;�,��Ac3%؍���¡���v/��0��z8��%��� ��Tn����]�þ㛹�N�^ۍ�/��-����ɷ��mI�!]?{)V[��_'.E{uY�O�b�ǃ�l�F��Dy�w#����c�O��ܤ]=�_EC�d�Ýw'(��B�dP	?�~�4�6��ٛ�ǣ�h�V�.&�6��(b+��T#f�j}h��L�3a�qG���m�p;뿿��O���E��o�����Y�`��,�s��*������z��t�'(��W�?�~��	�ߕࣿ�O�n0�,���?��4N������$N��i��*P�?�zB�z����1�������?�_x��3Yg�o��y�X�v�pG���l�S�]��_���RD�%�C&�o��E��qS���W���{��.�,?��~�X~�7��*��KϷ8|o]���X�Ûuys.o�%؟cKƎ�Hq��iդo��!I�m���n)����5rvmTl����F�j_e����1ɟ<��bR-NF�kQ��f��=�d׮��mj]��S���b�|1q��s�����7���]_/k!�S��XT����=��s}��4��31Sb+�d�s{SgG5$k�-?"������ٱ��2"ϡ��V>mt��\��숊���D.z��KDLw+8	f6��#N&�y �6�&��H�F��R�6}���S��o����*qOm*���x^8쾲���$�s7��ߊP���X��n�4�s*$���4
s�&�7��<�hJ���!�Q ~���6�?
(�����W����W��+l<;���`������Q0���c�=���3r�Iї��{��g���G���
�����������0�_@A�u�����|���CU\�W�?�~���W	^��z�����ځ?��<���b��p������;��a��2P�̓�w3ذ�y���~��x7�{��71$�����~/��6�Ϣ��ݱ��hu�#+�݆�����v@�O�L�f�k���H6��K�EȊ�&��<k��G�9?��M�'Z��l?콾ߋ�=���@-7�$6�Dt��<jp��o�;Q��eڲ��XԦ�RԱǾ��L��j0i��p7��;ф�W���D�q&hZ�f�!�_����[ʜh.�m���Q�;m{cm٥��f�����q������ �G>�����JP����ِ#��	���$y������E�<��y�ǯ�%�j�O0�O���(0�>U\���(���J�+��V��dm"2Z��9�,��h�7��0��J�U�:�r�I��/[n�{�l������-���G��U��U���?�_�����v�G$��_7�C�W}����c ��������w�?GB�_	^��ȷ������ִ��4wc�^O�{�<>.����/�pI{��}�c�G/�>*s���}mI�DqT�P�s�^Leu1���9����o���Ė<�;�;��+�n�a�vV�1��~�V`����=��}q�;�ĞI'�p��>R����{�Ω�S��^2Zʍ��+�[��^f����+�������2��]Wy[	/�u���V<-�q䎫�x���N�CO�h�k�f�����V�(��nwX�SuUa0�װ�Y������ۮ���+-WĬ%p���j�э^�������e�G�)I�2��n���3����t;��Tk����w~���Im�F�í:r$Ek^����uՅ��wusR�X�ldi��j0�����&m5���YS�z���
Ne����b����ʼ`��1��~yA�4�"��e��v���7�e�`�Q������LȢ�7up��
���m��A�a�'td���?r��_��E�������O����O����G��O9�0�K���o�/�����X��\�ȅ�U�-�������ߠ�����`����������,~������lȅ��W�ߡ�gFd��Wa��#�����#��3����Q_; ���^�i�*�����u!����\���P��Y������J����CB��l��P��?�/����㿐��	(�?H
A���m��B��W� �##�����\��W�R���� ������0��_��ԅ@���m��B�a�9����\��W�R����L��P��?@����7�?��O&���"ׁ�Ā���_.���Q��2!����ȅ���Ȁ�������%����"P�+��~h��������˃��+��Ȉ\���e�F����Yfh��v�����v��Z_�(��L�6�z��e,�L�E����я�uz��E������lx��wz�(u��<}������BSl*�q���L9�[���׉\2��cݮ�q��ŝ�E�b��-Ng�A���z�v�z0r�=�nJ��p��4=�ݢ�6肸�"b��6C�VXK��C�	��kb��q��T嘣<Q�yŉl�)I�Q���Y	4���wuQ�<g������@���k���y����CG��ЁR�/_�����[�~Ƀ����������Ӥ�]�ס��D$�����i���8�i[�wqu�s����.�V�y�=Xm3�{䶺�P������
G4گ���~��[��Il��p��b�]ce5�.�����:DC��S�'���V���a�(�S4ß�Q�F�"���_���_���?`�!�!���X���c(����������G���r�D������Ud��;?��W�~w���)VĪ8S��X��ف����6��h�@����{�.K�l�?���E��uc4oޤ��D�0.L�d\��iϱS�ʩI�˓M�N�=z�\��w�]��a���K�"n�s��.��矲��a�d�����grBё�b׬<�)$SQ�k�߽"<ق�K���F_�]>ܔ���:o��^�|�+�OMm����%�N-wz�U�jso�i�m�Åu�l*S!i��aZ�e	S��c!��PH����fi��c(��%mS!�v����Oo�&��B�'T����y��)Y��_��#o���dA.�����Ń�gAf����u�?�����Z�i���gy�?���9	u�9�����������?��\�_-��-������܈����Lȓ�C���J�����9��?~<P��?B���%�uc��L@n��
�H�����\�?������?,���\���u�/�������9�C����ƥ}{�bG[2ߛpsۼ������I������O���
��rWO��/��J��9�{C��)_r�/y�/����~�E7�׺≪��'qZ�t�겋��3�����joH՘�
�������icXf(I|�1BT�ǧɦ�9�h�s�/��y�/i�؍�_ݐOW���R�F��u��
�s8V�վ��tu����_��X�Ug��`1�lF9�&<���%i됬At��j��X==j�h�2�Vl�X���`�Va��cu�1��6�}"<��bu?���`����W���n�{�����r��0���<���KȔ\��7�Q0��	P��A�/�����g`��������n�������r��,	������=` �G������%��R9������m�~������)���r�����:�}�?I�ex��77���_��, {��C@im���1d:^]���Z�M��}M���v�����Y|�oE��{�DU��4�-��т���V��V�˲J6F�� `�$������ �,��IOP�q}]X��@�R�������R8O��[~хE5*�֞,]I٨�i)��V�-�e���v�&�H"�28�`���J���ӻ��L.�?���/P�+��G��	���m��A��ԍ��E��,ȏ�3e�7�"oۜn��n͋�A�,ip�A��M�d�l��i�:O�6kZ�Y�O�9�}���ߟ�<����?!�?����~��]�+��,�O�H!O��S�Q�Mf��f���4.^��<���&�{�`�.���
ND�sV�5��X5YNQ�[��\�N%�.,OÎ�E>��5b�Ld�.u��rٍ'���[�C��?с��?/���<�����#��?�@��ϋ �n ꦸK������{��x�/�U��h"1'�
�b��Rly�V#�����č�����KGv;l� *L���5!%T�>f� >��;!�#ި�b~ly�]����d<�����M�����ch���J>����/�g����������E��!� �� ����C9�6 �`��l�?D|����?G�h�5f���}�&����-�]�t�������i�}[ ������ʉv�Z�⭮w���N�V���醹ZT�Q�E��S[Es9+�����p���Z�<�O�ި�A�5�4+��mq�����S3;�y�.$�'>]�ZO���ք�<&)BwX���y� v+a��$:=�փRI�⡡�dU2�ٶ�bM�Uv�L0���(�g᫃��Y�&��t�O�Z��m��^�>+(�T,�J�{Z�j�)�#��-�%��C�vfǖ=��Du��Fc$��"�7ܞ�����F�6s����Q�i����_��?�}c����m}���dR�����aA���ҝ;�����P�-��s�������oRE=~�UA��{�����گ�t��_|8�!}�][��|�/���~M�F�����],�}s�?~�����G��Ϗ(-tϳ�/��B+=��7��5/o�w,��Z��/�������y��~J��Ӗ�h�u���?��>�i����ς�a�a������7�}��0�q+���x�^���������<z�"+����3J�x��ps�V���-3��#VQ{����_�9����<}c���~�}�=�I������;�?����'$��UzT��#����݇���(������}���>�������������|������x�X�ښ;V�_	<��'$���L==�o_�/E*^���\��שD���߸E;�TT��7x?P�r{8����zx�&o�1��0�\��/����w,Z[V��[ӳ�����z���5��`�x`Y!����Qz�eܼ���o���œ,�����znnMb��u�%���|���SJ[��E<~r�-&�{���,��7��ݪ��SGuu�$�]t������y�woj���t��/��+;�я����]�3                           �����}GT � 