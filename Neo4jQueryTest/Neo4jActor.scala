package com.wingman.neo4j

import akka.actor.{Actor, ActorLogging, ActorSystem, Props}
import org.neo4j.driver.{AuthTokens, Driver, GraphDatabase, Session, SessionConfig, Transaction, TransactionWork}
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.scala.DefaultScalaModule

case class Property(name: String, `type`: String, value: Object, unique: Option[Boolean] = None)
case class Node(label: String, properties: List[Property], primaryKey: String)
case class Relationship(`type`: String, startNode: RNode, endNode: RNode, properties: List[Property])
case class RNode(`type`:String, name: String, value: String)
case class Constraint(`type`: String, nodeLabel: String, property: String)
case class GraphData(nodes: List[Node], relationships: List[Relationship])

class Neo4jActor (driver: Driver) extends Actor {

  // Set up the Neo4j session
  def createSession: Session = driver.session(SessionConfig.builder()
    .withDatabase("neo4j")
    .build())

  // Method to insert nodes
  def insertNode(node: Node): Unit = {
    val session = createSession
    try {
      // Converts the properties to a string format for Cypher query
      val propertiesString = node.properties.map(p => s"${p.name}: '${p.value}'").mkString(", ")
      //val propertiesMap: Map[String, Object] = (node.properties.map(p => p.name -> p.value).toMap)

      // For instance: CREATE (n:Label {properties})
      val query = s"CREATE (n:${node.label} {$propertiesString})"
      session.run(query)
    }
    catch{
      case _: Throwable =>
    }
    finally {
      session.close()
    }
  }

  // Method to insert relationships
  def insertRelationship(relationship: Relationship): Unit = {
    val session = createSession
    try {
      //val propertiesString = relationship.properties.map(p => s"'${p.name}': '${p.value}'").mkString(", ")
      val query =
        s"""MATCH (a:${relationship.startNode.`type`} {${relationship.startNode.name}:'${relationship.startNode.value}'}), (b:${relationship.endNode.`type`}  {${relationship.endNode.name}:'${relationship.endNode.value}'}) CREATE (a)-[r:${relationship.`type`}]->(b)""".stripMargin
      //val propertiesMap: Map[String, Object] = (relationship.properties.map(p => p.name -> p.value).toMap)
      //(charlie:Person {name: 'Charlie Sheen'})

      session.run(query)
    }
    catch{
      case _: Throwable =>
    }
    finally {
      session.close()
    }
  }

  // Method to insert constraints (unique constraints) // It only creates a rule in the database
  def insertConstraints(constraint: Constraint): Unit = {
    val session = createSession
    try {
      val query = s"CREATE CONSTRAINT ON (n:${constraint.nodeLabel}) ASSERT n.${constraint.property} IS UNIQUE"
      session.run(query)
    } finally {
      session.close()
    }
  }

  // defines how the actor handles incoming messages
  override def receive: Receive = {
    // It expects a JSON string -> parses it into GraphData -> inserts the nodes and relationships into Neo4j.
    case jsonString: String =>
      val objectMapper = new ObjectMapper()
      objectMapper.registerModule(DefaultScalaModule)

      // Converts the JSON string to GraphData object
      val graphData = objectMapper.readValue(jsonString, classOf[GraphData])

      // Insert nodes
      graphData.nodes.foreach(insertNode)

      // Insert relationships
      graphData.relationships.foreach(insertRelationship)

      //Insert constraints
      //graphData.constraints.foreach(insertConstraints)

      println(s"Data inserted into Neo4j: $graphData")
      sender() ! "Data inserted into Neo4j successfully."
  }
}