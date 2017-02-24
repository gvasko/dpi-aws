import java.util.logging.Logger
import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.plugins.credentials.domains.*

Logger LOGGER = Logger.getLogger('jenkins.util.groovy.GroovyHookScript')

def env = System.getenv()


// if (!env.containsKey('JENKINS_HOME')) {
//     LOGGER.info('Credentials - JENKINS_HOME environment variable not found')
//     return
// }
LOGGER.info('#DPI: Credentials ...')

try {
	// def nodePropertiesFilePath = env['JENKINS_HOME'] + '/init.groovy.d/node.variables'

	// Properties nodeProperties = new Properties()
	// File nodePropertiesFile = new File(nodePropertiesFilePath)
	// nodePropertiesFile.withInputStream {
	// 	nodeProperties.load(it)
	// }

	def userId = 'JENKINS_USER_ID'
	def paramUsername = 'jenkins'     //nodeProperties.'BUILD_NODE_USER'
	def paramPassword = 'jenkins'     //nodeProperties.'BUILD_NODE_PASSWORD'

    def credentials_store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
    def global = Domain.global()

	def alreadyCreated = credentials_store.getCredentials(global).find { it.getId() == userId } != null

	if (alreadyCreated) {
	    LOGGER.info('#DPI: Credentials - already created')
	} else {
	    def scope = CredentialsScope.GLOBAL
	    def credentials = new UsernamePasswordCredentialsImpl(scope, userId, 'Jenkins User for the Attached Nodes', paramUsername, paramPassword)
	    credentials_store.addCredentials(global, credentials)
	    LOGGER.info('#DPI: Credentials - successfully created')
	}
}
catch (Exception e) {
    LOGGER.warning('#DPI: Credentials - exception: ' + e.getClass().getName())
    LOGGER.warning('#DPI: Credentials - exception: ' + e.getMessage())
}
