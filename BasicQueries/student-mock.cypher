// Create 4 Students
CREATE 
  (alice:STUDENT {name: "Alice Chen", age: 20, gpa: 3.8, major: "Computer Science", year: "Junior"}),
  (bob:STUDENT {name: "Bob Johnson", age: 21, gpa: 3.5, major: "Mathematics", year: "Senior"}),
  (clara:STUDENT {name: "Clara Martinez", age: 19, gpa: 3.9, major: "Biology", year: "Sophomore"}),
  (david:STUDENT {name: "David Kim", age: 22, gpa: 3.6, major: "Engineering", year: "Senior"}),

// Create 4 Courses
  (cs101:COURSE {code: "CS101", title: "Intro to Programming", credits: 4}),
  (math201:COURSE {code: "MATH201", title: "Calculus II", credits: 3}),
  (bio101:COURSE {code: "BIO101", title: "Biology Fundamentals", credits: 4}),
  (eng202:COURSE {code: "ENG202", title: "Thermodynamics", credits: 3}),

// Create 2 Study Groups
  (sg1:STUDY_GROUP {name: "CS Study Group", meeting_day: "Tuesday"}),
  (sg2:STUDY_GROUP {name: "Science Study Group", meeting_day: "Thursday"})

// Enrollment Relationships
CREATE
  (alice)-[:ENROLLED_IN {semester: "Fall 2023", grade: "A"}]->(cs101),
  (alice)-[:ENROLLED_IN {semester: "Fall 2023", grade: "B+"}]->(math201),
  (bob)-[:ENROLLED_IN {semester: "Fall 2023", grade: "A-"}]->(math201),
  (clara)-[:ENROLLED_IN {semester: "Fall 2023", grade: "A"}]->(bio101),
  (david)-[:ENROLLED_IN {semester: "Fall 2023", grade: "B+"}]->(eng202),
  (david)-[:ENROLLED_IN {semester: "Fall 2023", grade: "A"}]->(cs101),

// Friendship Relationships
  (alice)-[:FRIENDS_WITH {since: "2021"}]->(bob),
  (alice)-[:FRIENDS_WITH {since: "2022"}]->(clara),
  (bob)-[:FRIENDS_WITH {since: "2020"}]->(david),
  (clara)-[:FRIENDS_WITH {since: "2023"}]->(david),

// Study Group Memberships
  (alice)-[:MEMBER_OF {role: "Leader"}]->(sg1),
  (bob)-[:MEMBER_OF {role: "Member"}]->(sg1),
  (clara)-[:MEMBER_OF {role: "Leader"}]->(sg2),
  (david)-[:MEMBER_OF {role: "Member"}]->(sg2),

// Project Collaborations
  (alice)-[:WORKED_WITH {project: "CS101 Final Project", duration: "2 weeks"}]->(bob),
  (clara)-[:WORKED_WITH {project: "Bio Research Paper", duration: "3 weeks"}]->(david)
