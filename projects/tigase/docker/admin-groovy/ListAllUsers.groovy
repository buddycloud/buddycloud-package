/*
 * Tigase Jabber/XMPP Server
 * Copyright (C) 2004-2008 "Artur Hefczyc" <artur.hefczyc@tigase.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. Look for COPYING file in the top folder.
 * If not, see http://www.gnu.org/licenses/.
 *
 * $Rev: $
 * Last modified by $Author: $
 * $Date: $
 */
/*
 Get list of online users script as described in XEP-0133:
 http://xmpp.org/extensions/xep-0133.html#get-idle-users
 
 AS:Description: Get list of all users
 AS:CommandId: http://jabber.org/protocol/admin#get-all-users
 AS:Component: sess-man
 */
package tigase.admin
import tigase.server.*
import tigase.util.*
import tigase.xmpp.*
import tigase.db.*
import tigase.xml.*
import tigase.vhosts.*

def JID = "domainjid"

def sessions = (Map<BareJID, XMPPSession>)userSessions
def vhost_man = (VHostManagerIfc)vhostMan
def p = (Packet)packet
def user_repo = (UserRepository)userRepository

def domainJid = Command.getFieldValue(packet, JID);

if (domainJid == null) {
	
	def result = p.commandResult(Command.DataType.form);

	Command.addTitle(result, "Requesting List of Users")
	Command.addFieldValue(result, "FORM_TYPE", "http://jabber.org/protocol/admin",
			"hidden")

	def vhosts = [];
	vhost_man.repo.allItems().each {
		vhosts += it.getVhost().toString()
	}
	vhosts = vhosts.sort();
	def vhostsArr = vhosts.toArray(new String[vhosts.size()]);
	Command.addFieldValue(result, JID, "", "The domain for the list of users", vhostsArr, vhostsArr);

	return result
}

def result = p.commandResult(Command.DataType.result)
try {
	
	domainBareJID = BareJID.bareJIDInstance(domainJid)
	
	def users = user_repo.getUsers();
	users.each {
		if (it.getDomain() != null && it.getDomain().equals(domainBareJID.getDomain())) {
		    XMPPSession session = sessions.get(BareJID.bareJIDInstanceNS(it.toString()))
			Command.addTextField(result, "user", 
	        	"{\"jid\": \"" + it + "\", \"local\": \"" + it.getLocalpart() + "\"" + 
	        	", \"active\": " + (session != null) + 
	        	", \"activeFor\": " + (session != null ? session.getLiveTime() : 0) + "}");
		}
	}
	
} catch (Exception ex) {
	Command.addTextField(result, "Note", "Problem accessing database, users not listed. ");
}
return result
