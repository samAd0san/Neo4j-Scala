// User skips from login directly to profile (bookmark)
MERGE (u:User {id: 'user1', name: 'user1'})
MERGE (login:URL {path: '/login', name: 'login'})
MERGE (profile:URL {path: '/profile', name: 'profile'})

MERGE (u)-[:VISITED]->(login)
MERGE (login)-[:DIRECT_ACCESS {reason: 'bookmark'}]->(profile)