% brew install podman
% podman machine init
% podman machine start
% podman pull cockroachdb/cockroach
% podman pod create --name crdb-pod -p 26257:26257 -p 8080:8080
% podman run -d --pod crdb-pod --name cockroachdb \
  cockroachdb/cockroach:v23.1.11 start-single-node \
  --insecure --advertise-addr=$(ipconfig getifaddr en0)

% podman ps

% podman logs cockroachdb

*Connect to CockroachDB*
% podman exec -it cockroachdb cockroach sql --insecure
  > This should show a database prompt. Type 'quit' to exit

On macOS, the Podman machine is typically configured to use user‐mode networking. This means that instead of getting its own routable IP address on your LAN, its ports are forwarded to your local machine (i.e. localhost).
% ipconfig getifaddr en0 // returns the IP address of en0, which happens to work for me.
% ifconfig  // lists all of the network interfaces; look for "status: active"
