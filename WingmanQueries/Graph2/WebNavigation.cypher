// Nodes: URLs (referer and destination), showing how users navigate the site via relationships like VISITED, NEXT. (The graph is Linear)

// Create the user with a display name
MERGE (u:User {id: 'user1', name: 'user1'})

// Create URL nodes with display names matching their path
MERGE (login:URL {path: '/login', name: 'login'})
MERGE (home:URL {path: '/home', name: 'home'})
MERGE (dashboard:URL {path: '/dashboard', name: 'dashboard'})
MERGE (profile:URL {path: '/profile', name: 'profile'})

// Create the linear navigation path
MERGE (u)-[:VISITED]->(login)
MERGE (login)-[:NEXT]->(home)
MERGE (home)-[:NEXT]->(dashboard)
MERGE (dashboard)-[:NEXT]->(profile)
