import java.util.*
import java.util.logging.Logger
import jenkins.model.*

Logger LOGGER = Logger.getLogger('jenkins.util.groovy.GroovyHookScript')

LOGGER.info('#DPI: Master config ...')

def jenkinsMaster = Jenkins.getInstance()

try {
	jenkinsMaster.setNumExecutors(0)

	def jdkList = new ArrayList<JDK>()
	jdkList.add(new JDK('openjdk7', '/usr/lib/jvm/java-7-openjdk-amd64/'))
	jdkList.add(new JDK('openjdk8', '/usr/lib/jvm/java-8-openjdk-amd64/'))
	            
	jenkinsMaster.setJDKs(jdkList)

	LOGGER.info('#DPI: Master config - successfully done')
}
catch (Exception e) {
    LOGGER.warning('#DPI: Master config - exception: ' + e.getClass().getName())
    LOGGER.warning('#DPI: Master config - exception: ' + e.getMessage())
}
