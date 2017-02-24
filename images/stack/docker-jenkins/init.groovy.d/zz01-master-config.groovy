import java.util.logging.Logger
import jenkins.model.*

Logger LOGGER = Logger.getLogger('jenkins.util.groovy.GroovyHookScript')

LOGGER.info('#DPI: Master config ...')

try {
	Jenkins.instance.setNumExecutors(0)
	LOGGER.info('#DPI: Master config - successfully created')
}
catch (Exception e) {
    LOGGER.warning('#DPI: Master config - exception: ' + e.getClass().getName())
    LOGGER.warning('#DPI: Master config - exception: ' + e.getMessage())
}
