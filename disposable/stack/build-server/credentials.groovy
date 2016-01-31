import java.util.logging.Logger
import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.plugins.credentials.domains.*

Logger LOGGER = Logger.getLogger('jenkins.util.groovy.GroovyHookScript')

def env = System.getenv()

if (!env.containsKey('BUILD_NODE_USERNAME')) {
    LOGGER.info('Credentials - BUILD_NODE_USERNAME environment variable not found')
    return
}

if (!env.containsKey('BUILD_NODE_PASSWORD')) {
    LOGGER.info('Credentials - BUILD_NODE_PASSWORD environment variable not found')
    return
}

def paramUsername = env['BUILD_NODE_USERNAME']
def paramPassword = env['BUILD_NODE_PASSWORD']

try {
    def credentials_store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
    def scope = CredentialsScope.GLOBAL
    def credentials = new UsernamePasswordCredentialsImpl(scope, 'JENKINS_USER_ID', 'Jenkins User for the Attached Nodes', paramUsername, paramPassword)
    def global = Domain.global()
    credentials_store.addCredentials(global, credentials)
    LOGGER.info('Credentials - successfully created')
}
catch (Exception e) {
    LOGGER.warning('Credentials - exception: ' + e.getClass().getName())
    LOGGER.warning('Credentials - exception: ' + e.getMessage())
}
