// User's specific journey with returns to home
MERGE (u:User {id: 'user1', name: 'user1'})
MERGE (login:URL {path: '/login', name: 'login'})
MERGE (home:URL {path: '/home', name: 'home'})
MERGE (dashboard:URL {path: '/dashboard', name: 'dashboard'})
MERGE (products:URL {path: '/products', name: 'products'})

// The actual path taken
MERGE (u)-[:VISITED {timestamp: datetime(), order: 1}]->(login)
MERGE (login)-[:NEXT {timestamp: datetime(), order: 2}]->(home)
MERGE (home)-[:NEXT {timestamp: datetime(), order: 3}]->(dashboard)
MERGE (dashboard)-[:NEXT {timestamp: datetime(), order: 4}]->(home)
MERGE (home)-[:NEXT {timestamp: datetime(), order: 5}]->(products)