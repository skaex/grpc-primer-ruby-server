# Get the lib directory
lib_dir = File.join(__dir__, 'lib')

# Add the lib directory to load path
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'messages_services_pb'

# HelloServer is the gRPC server implementation
class HelloServer < HelloService::Service
  def say_hello(hello_req, _unused_call)
    HelloResponse.new(Message: "Hello #{hello_req.Name}")
  end
end

def main
  server = GRPC::RpcServer.new
  server.add_http2_port('localhost:50000', :this_port_is_insecure)
  server.handle(HelloServer)
  server.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])
end

main
