import java.util.logging.Logger
import jenkins.*
import jenkins.model.*
import hudson.*
import hudson.model.*
import hudson.slaves.*
import hudson.plugins.sshslaves.*

Logger LOGGER = Logger.getLogger('jenkins.util.groovy.GroovyHookScript')

LOGGER.info('#DPI: Discover docker containers to attach as build nodes ...')
  
def jenkinsMaster = Jenkins.getInstance()
def baseUrl = jenkinsMaster.getRootUrl()
def dockerServerUrl = baseUrl.replaceFirst('/$', ':4243/v1.24')
println 'docker server: ' + dockerServerUrl
 
def containersText = new URL(dockerServerUrl + '/containers/json').text

def slurper = new groovy.json.JsonSlurper()

def containers = slurper.parseText(containersText)

try {
	containers.findAll { it.Names[0] != '/jenkins' }.each {
		def nodeName = it.Names[0].substring(1)

		def alreadyAdded = jenkinsMaster.getNodes().find { it.getDisplayName() == nodeName } != null

		if (alreadyAdded) {
			LOGGER.info('#DPI: Build node - already added: ' + nodeName)
		} else {
			LOGGER.info('#DPI: Build node - created: ' + nodeName)
		}

		def nodeIPAddress = it.NetworkSettings.Networks['bridge'].IPAddress
		def label = nodeName.split('-')[1]
		def sshLauncher = new SSHLauncher(nodeIPAddress, 22, 'JENKINS_USER_ID', '', '', '', '', 5, 3, 10)
		def slave = new DumbSlave(nodeName, '/home/jenkins', sshLauncher)
		slave.with {
			setNodeDescription('automatically discovered')
			setNumExecutors(1)
			setMode(Node.Mode.NORMAL)
			setLabelString(label)
		}

		jenkinsMaster.addNode(slave)

		LOGGER.info('#DPI: Build node - successfully created')
	}
}
catch(Exception e) {
	LOGGER.warning('#DPI: Build nodes - exception: ' + e.getClass().getName())
	LOGGER.warning('#DPI: Build nodes - exception: ' + e.getMessage())
}


return
