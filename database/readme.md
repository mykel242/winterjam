% brew install podman
% podman machine init
% podman machine start
% podman pull cockroachdb/cockroach
% podman pod create --name crdb-pod -p 26257:26257 -p 8080:8080
% podman run -d --pod crdb-pod --name cockroachdb \
  cockroachdb/cockroach:v23.1.11 start-single-node \
  --insecure --advertise-addr=$(ipconfig getifaddr en0)

 /*---
    Explanation:
  	•	start-single-node → Runs CockroachDB as a single-node deployment.
  	•	--insecure → Disables TLS authentication (for testing).
  	•	--advertise-addr=0.0.0.0 → Allows external connections.

   - -advertise-addr=$(ipconfig getifaddr en0)
   This command uses $(ipconfig getifaddr en0) to dynamically insert your current IP address for the en0 interface into the command.
---*/

 % podman ps

/*---
 CONTAINER ID  IMAGE                                     COMMAND               CREATED             STATUS             PORTS                                             NAMES
 4ba8ffdee622  localhost/podman-pause:5.4.0-1739232000                         6 minutes ago       Up About a minute  0.0.0.0:8080->8080/tcp, 0.0.0.0:26257->26257/tcp  b45f72835d78-infra
 3a96f8e467e2  docker.io/cockroachdb/cockroach:v23.1.11  start-single-node...  About a minute ago  Up About a minute  0.0.0.0:8080->8080/tcp, 0.0.0.0:26257->26257/tcp  cockroachdb
---*/

% podman logs cockroachdb

*Connect to CockroachDB*
% podman exec -it cockroachdb cockroach sql --insecure
  > This should show a database prompt. Type 'quit' to exit
"""
When running CockroachDB in a container that should be accessible externally, one key point is ensuring that the node advertises the correct, externally reachable address. Using --advertise-addr=0.0.0.0 means the node isn’t telling clients which specific IP to use when connecting from outside its container, which can lead to connection issues.
"""
- Determine the Reachable IP.
- Update the Advertise Address.
- Port Forwarding and Firewall
  - You’ve already mapped ports 26257 and 8080 to the host with the pod creation command.
  - These ports are not blocked by your macOS firewall.
  - If you’re connecting from another machine, you’re using the correct IP.
- Security Considerations
  - DEV only.
- Verify Connectivity
  - % podman logs cockroachdb
  - Test connectivity from an external client using the advertised IP and port 26257 for SQL connections or port 8080 for the admin UI.
---
On macOS, the Podman machine is typically configured to use user‐mode networking. This means that instead of getting its own routable IP address on your LAN, its ports are forwarded to your local machine (i.e. localhost).
% ipconfig getifaddr en0 // returns the IP address of en0, which happens to work for me.
% ifconfig  // lists all of the network interfaces; look for "status: active"
---
How to Expose CockroachDB Externally.
----
