// Graph 1: Fraud Detection
// MERGE (fd_u1:User:Graph1 {id: 'user1', name: 'User1'})
// MERGE (fd_u2:User:Graph1 {id: 'user2', name: 'User2'})
// MERGE (fd_u3:User:Graph1 {id: 'user3', name: 'User3'})

// MERGE (fd_ip1:IPAddress:Graph1 {address: '127.0.0.1', name: 'IP Address 1'})
// MERGE (fd_ip2:IPAddress:Graph1 {address: '192.168.1.10', name: 'IP Address 2'})

// MERGE (fd_d1:Device:Graph1 {id: 'deviceX', name: 'Device X'})
// MERGE (fd_d2:Device:Graph1 {id: 'deviceY', name: 'Device Y'})

// MERGE (fd_b1:Browser:Graph1 {name: 'Chrome'})
// MERGE (fd_b2:Browser:Graph1 {name: 'Firefox'})

// MERGE (fd_m1:Module:Graph1 {name: 'login'})
// MERGE (fd_m2:Module:Graph1 {name: 'payment'})

// MERGE (fd_u1)-[:USED_IP]->(fd_ip1)
// MERGE (fd_u2)-[:USED_IP]->(fd_ip1)
// MERGE (fd_u3)-[:USED_IP]->(fd_ip2)

// MERGE (fd_u1)-[:USED_DEVICE]->(fd_d1)
// MERGE (fd_u2)-[:USED_DEVICE]->(fd_d1)
// MERGE (fd_u3)-[:USED_DEVICE]->(fd_d2)

// MERGE (fd_u1)-[:USED_BROWSER]->(fd_b1)
// MERGE (fd_u2)-[:USED_BROWSER]->(fd_b1)
// MERGE (fd_u3)-[:USED_BROWSER]->(fd_b2)

// MERGE (fd_u1)-[:ACCESSED_MODULE {valid: false}]->(fd_m1)
// MERGE (fd_u2)-[:ACCESSED_MODULE {valid: false}]->(fd_m1)
// MERGE (fd_u3)-[:ACCESSED_MODULE {valid: true}]->(fd_m2)

// Maintain all existing data except User3's login attempts
MERGE (fd_u1:User:Graph1 {id: 'user1', name: 'User1'})
MERGE (fd_u2:User:Graph1 {id: 'user2', name: 'User2'})
MERGE (fd_u3:User:Graph1 {id: 'user3', name: 'User3'})

MERGE (fd_ip1:IPAddress:Graph1 {address: '127.0.0.1', name: 'IP Address 1'})
MERGE (fd_ip2:IPAddress:Graph1 {address: '192.168.1.10', name: 'IP Address 2'})

MERGE (fd_d1:Device:Graph1 {id: 'deviceX', name: 'Device X'})
MERGE (fd_d2:Device:Graph1 {id: 'deviceY', name: 'Device Y'})

MERGE (fd_b1:Browser:Graph1 {name: 'Chrome'})
MERGE (fd_b2:Browser:Graph1 {name: 'Firefox'})

MERGE (fd_m1:Module:Graph1 {name: 'login'})
MERGE (fd_m2:Module:Graph1 {name: 'payment'})

// Maintain all existing relationships except User3's login attempts
MERGE (fd_u1)-[:USED_IP]->(fd_ip1)
MERGE (fd_u2)-[:USED_IP]->(fd_ip1)
MERGE (fd_u3)-[:USED_IP]->(fd_ip2)

MERGE (fd_u1)-[:USED_DEVICE]->(fd_d1)
MERGE (fd_u2)-[:USED_DEVICE]->(fd_d1)
MERGE (fd_u3)-[:USED_DEVICE]->(fd_d2)

MERGE (fd_u1)-[:USED_BROWSER]->(fd_b1)
MERGE (fd_u2)-[:USED_BROWSER]->(fd_b1)
MERGE (fd_u3)-[:USED_BROWSER]->(fd_b2)

MERGE (fd_u1)-[:ACCESSED_MODULE {valid: false}]->(fd_m1)
MERGE (fd_u2)-[:ACCESSED_MODULE {valid: false}]->(fd_m1)

// Create multiple successful login attempts for User3 with timestamps
FOREACH (i IN range(1, 5) | 
  MERGE (fd_u3)-[r:ACCESSED_MODULE {valid: true, timestamp: datetime(), count: i}]->(fd_m1)
)

// Maintain User3's payment access
MERGE (fd_u3)-[:ACCESSED_MODULE {valid: true}]->(fd_m2)

// Graph 2: Web Navigation (Linear)
MERGE (wn_u:User:Graph2 {id: 'user1', name: 'user1'})
MERGE (wn_login:URL:Graph2 {path: '/login', name: 'login'})
MERGE (wn_home:URL:Graph2 {path: '/home', name: 'home'})
MERGE (wn_dashboard:URL:Graph2 {path: '/dashboard', name: 'dashboard'})
MERGE (wn_profile:URL:Graph2 {path: '/profile', name: 'profile'})

MERGE (wn_u)-[:VISITED]->(wn_login)
MERGE (wn_login)-[:NEXT]->(wn_home)
MERGE (wn_home)-[:NEXT]->(wn_dashboard)
MERGE (wn_dashboard)-[:NEXT]->(wn_profile)

// Graph 3: Bookmark
MERGE (bm_u:User:Graph3 {id: 'user1', name: 'user1'})
MERGE (bm_login:URL:Graph3 {path: '/login', name: 'login'})
MERGE (bm_profile:URL:Graph3 {path: '/profile', name: 'profile'})

MERGE (bm_u)-[:VISITED]->(bm_login)
MERGE (bm_login)-[:DIRECT_ACCESS {reason: 'bookmark'}]->(bm_profile)

// Graph 4: User Return Home
MERGE (urh_u:User:Graph4 {id: 'user1', name: 'user1'})
MERGE (urh_login:URL:Graph4 {path: '/login', name: 'login'})
MERGE (urh_home:URL:Graph4 {path: '/home', name: 'home'})
MERGE (urh_dashboard:URL:Graph4 {path: '/dashboard', name: 'dashboard'})
MERGE (urh_products:URL:Graph4 {path: '/products', name: 'products'})

MERGE (urh_u)-[:VISITED {timestamp: datetime(), order: 1}]->(urh_login)
MERGE (urh_login)-[:NEXT {timestamp: datetime(), order: 2}]->(urh_home)
MERGE (urh_home)-[:NEXT {timestamp: datetime(), order: 3}]->(urh_dashboard)
MERGE (urh_dashboard)-[:NEXT {timestamp: datetime(), order: 4}]->(urh_home)
MERGE (urh_home)-[:NEXT {timestamp: datetime(), order: 5}]->(urh_products)

// Graph 5: No Referrer
MERGE (nr_noref:Referrer:Graph5 {type: 'empty', name: 'NOREFERRER'})
MERGE (nr_profile:URL:Graph5 {path: '/profile', name: 'profile'})

MERGE (nr_noref)-[:DIRECT_ACCESS {reason: 'no_referrer'}]->(nr_profile)
