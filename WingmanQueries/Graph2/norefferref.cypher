// Suspicious access with no referrer
MERGE (noref:Referrer {type: 'empty', name: 'NOREFERRER'})
MERGE (profile:URL {path: '/profile', name: 'profile'})

MERGE (noref)-[:DIRECT_ACCESS {reason: 'no_referrer'}]->(profile)