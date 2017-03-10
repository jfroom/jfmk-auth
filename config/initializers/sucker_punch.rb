# ex    => The caught exception object
# klass => The job class
# args  => An array of the args passed to the job

SuckerPunch.exception_handler = -> (ex, klass, args) { ExceptionNotifier.notify_exception(ex) }
