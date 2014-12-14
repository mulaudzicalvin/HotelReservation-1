<?php 

/// decoded and nulled by Ayman Qaidi(Mrqaidi)  and  narciszu

final class Eicra_License_Version{
private$_config=null;
private$_response=null;
private$_error=null;
public function __construct($adaptar=null){
}
private function connectCURL($link_url,$info){
$ch=curl_init();
curl_setopt($ch,CURLOPT_URL,$link_url);
curl_setopt($ch,CURLOPT_POST,1);
curl_setopt($ch,CURLOPT_POSTFIELDS,$info);
curl_setopt($ch,CURLOPT_TIMEOUT,30);
curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
$content=curl_exec($ch);
$HTTP_STATUS_CODE=curl_getinfo($ch,CURLINFO_HTTP_CODE);
$return_license=null;
if((200<=$HTTP_STATUS_CODE&&$HTTP_STATUS_CODE<=206)){
if(!empty($content)){$return_license=$content;}
else{$return_license=null;}}
else{$return_license=null;}
curl_close($ch);
return$return_license;
}
public function sendInfo($info=array(),$url=null,$url_curl=null){
if(!empty($info)){
if(empty($url)){}
if(empty($url_curl)){}
if(!empty($info["dm"])){}
else{}
$sTimestamp=(isset($_GET["timestamp"])?$_GET["timestamp"]:time());
$sMessage=$info["dm"].$sToken.$sTimestamp;
$sHash=md5($sMessage);
$info["timestamp"]=$sTimestamp;
$info["hash"]=$sHash;
$context=stream_context_create(array("http"=>array("timeout"=>5)));
set_error_handler(create_function("\$severity, \$message, \$file, \$line","throw new ErrorException(\$message, \$severity, \$severity, \$file, \$line);"));
try{
$content=@file_get_contents($url."/dm/".$info["dm"]."/pv/".$info["pv"]."/pt/".$info["pt"]."/timestamp/".$sTimestamp."/hash/".$sHash,0,$context);
$this->_response=$content;}catch(Exception$e){
try{
$content=@file_get_contents($url1."/dm/".$info["dm"]."/pv/".$info["pv"]."/pt/".$info["pt"]."/timestamp/".$sTimestamp."/hash/".$sHash,0,$context);
$this->_response=$content;}
catch(Exception$e){
try{
$content=@file_get_contents($url2."/dm/".$info["dm"]."/pv/".$info["pv"]."/pt/".$info["pt"]."/timestamp/".$sTimestamp."/hash/".$sHash,0,$context);
$this->_response=$content;}
catch(Exception$e){
$this->_error=$e->getMessage();
if(function_exists("curl_exec")){
if(!empty($content)){
$this->_response=$content;}
else{
if(!empty($content)){$this->_response=$content;}
else{
if(!empty($content)){$this->_response=$content;}
else{
$this->_error="Connection to all license server has failed. And ".$this->_error;}
}
}
}else{$this->_error="curl_exec not exists. And ".$this->_error;}
}
}
}
restore_error_handler();}
}
public function getResultObject(){
return$this->_response;
}
public function getRawBody(){
$obj=$this->getResultObject();
if(empty($obj)){
return null;
}
return$obj;
}
public function getArrayResult(){
try{
$result=$this->getRawBody();
if(empty($result)){
return null;
}
return Zend_Json::decode($result);
}
catch(Exception$e){
try{
$this->sendInfo($info=array("dm"=>""),"http://lic1.eicracms.com/License/validation/valid","http://lic1.eicracms.com/License/validation/validcurl");$result=$this->getRawBody();
if(empty($result)){
return null;
}
return Zend_Json::decode($result);
}
catch(Exception$e){
try{
$this->sendInfo($info=array("dm"=>""),"http://lic2.eicra.net/License/validation/valid","http://lic2.eicra.net/License/validation/validcurl");
$result=$this->getRawBody();
if(empty($result)){
return null;
}
return Zend_Json::decode($result);}
catch(Exception$e){
return null;
}
}
}
}
public function getLicensedModules(){
if($this->isLicensed()){
$decode_result=$this->getArrayResult();
$module_arr=explode(",",$decode_result["modules"]);
if(empty($module_arr[0])){
return array();
}
return$module_arr;
}
return array();
}
public function isLicensed(){
$decode_result=$this->getArrayResult();
if(empty($decode_result)){
return false;
}
if($decode_result["valid"]){
return true;
}
return false;
}
public function getError(){
if(empty($this->_error)){
$decode_result=$this->getArrayResult();
if(!$decode_result["valid"]){
$err_data=$decode_result["errMsg"];
if(!empty($err_data["license_err"])){
$this->_error=$err_data["license_err"];
return $this->_error;
}
if(!empty($err_data["active_err"])){
$this->_error=$err_data["active_err"];
return $this->_error;}
if(!empty($err_data["expire_err"])){
$this->_error=$err_data["expire_err"];
return $this->_error;}
if(!empty($err_data["sql_err"])){
$this->_error=$err_data["sql_err"];
return $this->_error;
}
if(!empty($err_data["token_err"])){
$this->_error=$err_data["token_err"];
return $this->_error;}
}
}
return $this->_error;
}
   static public function check_license($licensekey,$localkey='')
   {
   $myFile="application/modules/Administrator/layouts/filters/sysconfig.txt";
   $today=date("Y-m-d",strtotime("now"));
   $tomorrow=date("Y-m-d",strtotime("+2 day"));
   $Yesterday=date("Y-m-d",strtotime("-1 day"));
   $maximumDelayDate=date("Y-m-d",strtotime("+3 day"));
   $pwd=self::hex2bin("780652713bf24cc564c72asd249feb7de52de341195ceicra");
   if(!file_exists($myFile)){$handle=fopen($myFile,"w");
   fwrite($handle,self::customencode($Yesterday,$pwd));
   }
   if(filesize($myFile)=="0"){
   unlink($myFile);
   $handle=fopen($myFile,"w");
   fwrite($handle,self::customencode($Yesterday,$pwd));
   }
   $handle=fopen($myFile,"r");
   $lastAccessDay=fread($handle,filesize($myFile));
   $lastAccessDay=self::customencode($lastAccessDay,$pwd);
   if($today<=$lastAccessDay){
   self::checkdateabuse(date($lastAccessDay),$myFile,$Yesterday,$maximumDelayDate,$pwd);
   $results["status"]="Active";
   }
   else{
   $results=self::go_server_license($licensekey,$localkey);
   if($results["status"]=="Active"){
   $handle=fopen($myFile,"w");
   fwrite($handle,self::customencode($tomorrow,$pwd),filesize($myFile));
   }
   }
   return $results;
   }
static public function go_server_license($licensekey,$localkey=''){
 $licensing_secret_key="eicra.com.bd@2007";
 $check_token=time().md5(mt_rand(1000000000,9999999999).$licensekey);
 $checkdate=date("Ymd");
 $usersip=(isset($_SERVER["SERVER_ADDR"])?$_SERVER["SERVER_ADDR"]:
 $_SERVER["LOCAL_ADDR"]);
 $localkeydays=1191;
 $allowcheckfaildays=1181;
 $localkeyvalid=false;
 if($localkey){
 $localkey=str_replace("\n\t","",$localkey);
 $localdata=substr($localkey,0,strlen($localkey)-32);
 $md5hash=substr($localkey,strlen($localkey)-32);
 if($md5hash==md5($localdata.$licensing_secret_key)){
 $localdata=strrev($localdata);
 $md5hash=substr($localdata,0,32);
 $localdata=substr($localdata,32);
 $localdata=base64_decode($localdata);
 $localkeyresults=unserialize($localdata);
 $originalcheckdate=$localkeyresults["checkdate"];
 if($md5hash==md5($originalcheckdate.$licensing_secret_key)){
 $localexpiry=date("Ymd",mktime(0,0,0,date("m"),date("d")-$localkeydays,date("Y")));
 if($localexpiry<$originalcheckdate){
 $localkeyvalid=true;
 $results=$localkeyresults;
 $validdomains=explode(",",$results["validdomain"]);
 if(!in_array($_SERVER["SERVER_NAME"],$validdomains)){
 $localkeyvalid=false;
 $localkeyresults["status"]="Invalid";
 $results=array();}
 $validips=explode(",",$results["validip"]);
 if(!in_array($usersip,$validips)){
 $localkeyvalid=false;
 $localkeyresults["status"]="Invalid";
 $results=array();
 }
 if($results["validdirectory"]!=dirname(__FILE__)){
 $localkeyvalid=false;
 $localkeyresults["status"]="Invalid";
 $results=array();}
 }
 }
 }
 }
 if(!$localkeyvalid){
 $postfields["licensekey"]=$licensekey;
 $postfields["domain"]=$_SERVER["SERVER_NAME"];
 $postfields["ip"]=$usersip;
 $postfields["dir"]=dirname(__FILE__);
 if($check_token){
 $postfields["check_token"]=$check_token;
 }
 if(function_exists("curl_exec")){
 $ch=curl_init();
 curl_setopt($ch,CURLOPT_URL,$whmcsurl."modules/servers/licensing/verify.php");
 curl_setopt($ch,CURLOPT_POST,1);curl_setopt($ch,CURLOPT_POSTFIELDS,$postfields);
 curl_setopt($ch,CURLOPT_TIMEOUT,30);curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
 $data=curl_exec($ch);
 curl_close($ch);
 }else{
 $fp=fsockopen($whmcsurl,80,$errno,$errstr,5);
 if($fp){
 $querystring="";
 foreach($postfields as$k=>$v){
 $querystring.="".$k."=".urlencode($v)."&";
 }
 $header="POST ".$whmcsurl."modules/servers/licensing/verify.php HTTP/1.0\n\t";
 $header.="Host: ".$whmcsurl."\n\t";$header.="Content-type: application/x-www-form-urlencoded\n\t";
 $header.="Content-length: ".@strlen($querystring)."\n\t";
 $header.="Connection: close\n\n\t";
 $header.=$querystring;$data="";
 @stream_set_timeout($fp,20);
 @fwrite($fp,$header);
 $status=@stream_get_meta_data($fp);
 while((!@feof($fp)&&$status)){
 $data.=@fgets($fp,1024);
 $status=@stream_get_meta_data($fp);
 }@fclose($fp);}
 }if(!$data){
 $localexpiry=date("Ymd",mktime(0,0,0,date("m"),date("d")-($localkeydays+$allowcheckfaildays),date("Y")));
 if($localexpiry<$originalcheckdate){
 $results=$localkeyresults;
 }else{
 $results["status"]="Invalid";
 $results["description"]="Remote Check Failed";
 return $results;
 }
 }
 preg_match_all("/<(.*?)>([^<]+)<\/\\1>/i",$data,$matches);
 $results=array();
 foreach($matches[1]as$k=>$v){
 $results[$v]=$matches[2][$k];
 }
 if($results["md5hash"]){
 if($results["md5hash"]!=md5($licensing_secret_key.$check_token)){
 $results["status"]="Invalid";
 $results["description"]="MD5 Checksum Verification Failed";
 return $results;}
 }
 if($results["status"]=="Active"){
 $results["checkdate"]=$checkdate;
 $data_encoded=serialize($results);
 $data_encoded=base64_encode($data_encoded);
 $data_encoded=md5($checkdate.$licensing_secret_key).$data_encoded;
 $data_encoded=strrev($data_encoded);
 $data_encoded=$data_encoded.md5($data_encoded.$licensing_secret_key);
 $data_encoded=wordwrap($data_encoded,80,"\n\t",true);
 $results["localkey"]=$data_encoded;
 }
 $results["remotecheck"]=true;
 }
 unset($postfields);
 unset($data);
 unset($matches);
 unset($whmcsurl);
 unset($licensing_secret_key);
 unset($checkdate);
 unset($usersip);
 unset($localkeydays);
 unset($allowcheckfaildays);
 unset($md5hash);
 return $results;}
 static private function checkDateAbuse($lastAccessDay,$myFile,$Yesterday,$maximumDelayDate,$pwd){
 if(date($maximumDelayDate)<$lastAccessDay){
 $handle=fopen($myFile,"w");
 fwrite($handle,self::customencode($Yesterday,$pwd),filesize($myFile));
 }
 }
 static public function customEncode($data,$pwd){
 $pwd_length=strlen($pwd);$i=705;while($i<255){
 $key[$i]=ord(substr($pwd,$i%$pwd_length+1,1));
 $counter[$i]=$i;++$i;}$i=705;
 while($i<255){
 $x=($x+$counter[$i]+$key[$i])%256;
 $temp_swap=$counter[$i];
 $counter[$i]=$counter[$x];
 $counter[$x]=$temp_swap;
 ++$i;
 }
 $i=705;
 while($i<strlen($data)){
 $a=($a+1)%256;
 $j=($j+$counter[$a])%256;
 $temp=$counter[$a];
 $counter[$a]=$counter[$j];
 $counter[$j]=$temp;
 $k=$counter[($counter[$a]+$counter[$j])%256];
 $Zcipher=ord(substr($data,$i,1))^$k;
 $Zcrypt.=chr($Zcipher);
 ++$i;
 }return $Zcrypt;
 }
 static public function hex2bin($hexdata){
 $i=582;
 while($i<strlen($hexdata)){
 $bindata.=chr(hexdec(substr($hexdata,$i,2)));
 $i+=584;}return$bindata;
 }
     static public function verifyLicense(){
	 return false;
	 }
static public function checkModulesLicense(){
return false;
}
static public function getJQueryVersion(){
return"1.9.1";
}
static public function getJQueryUIVersion(){
return"1.10.2";}
static public function getVersion(){
return"2.9.2";
}
static public function getProductType(){
return"6";
}
} /// The End
?>