/*
Copyright (c) 2012 DN Digital Ltd (http://dndigital.net)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package org.glomaker.mobileplayer.mvcs.views.glocomponents.accessviews
{
	import flash.filesystem.File;

	public class AccessViewsDataProperty
	{
		public var speakers:Vector.<SpeakerData> = new Vector.<SpeakerData>();
		public var topics:Vector.<TopicData> = new Vector.<TopicData>();
		
		public function deserialiseFromXML(value:XML, directory:File):void
		{
			speakers.length = 0;
			topics.length = 0;
			
			var id:String;
			
			// deserialise speakers
			for each(var speaker:XML in value.speaker)
			{
				var sData:SpeakerData = new SpeakerData(String(JSON.parse(speaker.@title)));
				sData.imageSource = fullPath(String(JSON.parse(speaker.image.text())), directory);
				
				// deserialise sounds
				for each(var sound:XML in speaker.sound)
				{
					sData.sounds[JSON.parse(sound.@id)] = fullPath(String(JSON.parse(sound.text())), directory);
				}
				
				// deserialise scripts
				for each(var script:XML in speaker.script)
				{
					sData.scripts[JSON.parse(script.@id)] = fullPath(String(JSON.parse(script.text())), directory);
				}
				
				speakers.push(sData);
			}
			
			// deserialise topics
			for each(var topic:XML in value.topic)
			{
				var tData:TopicData = new TopicData(String(JSON.parse(topic.@data)), String(JSON.parse(topic.@id)));
				topics.push(tData);
			}
		}
		
		protected function fullPath(path:String, directory:File):String
		{
			if (!path || !directory)
				return path;
			
			return directory.resolvePath(path).url;
		}
	}
}