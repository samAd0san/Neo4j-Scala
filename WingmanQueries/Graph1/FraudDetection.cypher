// Scenario 1 shows a single legitimate user with successful login.
// Scenario 2 highlights multiple users using the same IP/device/browser with failed logins, which could indicate coordinated or fraudulent activity.
// From this graph we can visualize the User which tried to access payment_module with successful login - when given true ( that is mentioned in ACCESSED_MODULE).

MERGE (u1:User {id: 'user1', name: 'User1'})
MERGE (u2:User {id: 'user2', name: 'User2'})
MERGE (u3:User {id: 'user3', name: 'User3'})

MERGE (ip1:IPAddress {address: '127.0.0.1', name: 'IP Address 1'})
MERGE (ip2:IPAddress {address: '192.168.1.10', name: 'IP Address 2'})

MERGE (d1:Device {id: 'deviceX', name: 'Device X'})
MERGE (d2:Device {id: 'deviceY', name: 'Device Y'})

MERGE (b1:Browser {name: 'Chrome'})
MERGE (b2:Browser {name: 'Firefox'})

MERGE (m1:Module {name: 'login'})
MERGE (m2:Module {name: 'payment'})

MERGE (u1)-[:USED_IP]->(ip1)
MERGE (u2)-[:USED_IP]->(ip1)
MERGE (u3)-[:USED_IP]->(ip2)

MERGE (u1)-[:USED_DEVICE]->(d1)
MERGE (u2)-[:USED_DEVICE]->(d1)
MERGE (u3)-[:USED_DEVICE]->(d2)

MERGE (u1)-[:USED_BROWSER]->(b1)
MERGE (u2)-[:USED_BROWSER]->(b1)
MERGE (u3)-[:USED_BROWSER]->(b2)

MERGE (u1)-[:ACCESSED_MODULE {valid: false}]->(m1)
MERGE (u2)-[:ACCESSED_MODULE {valid: false}]->(m1)
MERGE (u3)-[:ACCESSED_MODULE {valid: true}]->(m2)
