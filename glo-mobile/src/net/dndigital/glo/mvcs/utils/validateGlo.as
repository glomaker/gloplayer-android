package net.dndigital.glo.mvcs.utils {
	import com.adobe.crypto.MD5;
	
	import eu.kiichigo.utils.log;

	public function validateGlo(xml:XML):Boolean {
		var nodeName:String = "filehash";
		
		// if no validation tag was found, then we can't validate, so assume invalid
		if(!xml.hasOwnProperty(nodeName))
			return false;
		
		// (Back door) ... exception, ignore the process of validation if the key word ignore is found! (Musbah: 09July09) .. to allow people to edit the XML file manually
		if(xml.child(nodeName) == "ignore")
			return true;
		
		var validationNode:String = xml.child(nodeName);
		delete xml.child(nodeName)[0];
		
		var hash:String = MD5.hash(xml.toXMLString());
		
		return hash == validationNode;
	}
}