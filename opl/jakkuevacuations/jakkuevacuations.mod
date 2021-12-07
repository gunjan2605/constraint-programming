/*********************************************
 * OPL 20.1.0.0 Data
 * Author: gunjan
 * Creation Date: Nov 20, 2021 at 8:32:26 AM
 *********************************************/

using CP;
 
int nbNodes = ...;
int nbPaths = ...;

int startEvacuationNodes = ...;
int endEvacuationNodes = ...;

range RPaths = 1..nbPaths;

tuple EvacuationNode {
	key int id;
	int demand;
};

{EvacuationNode} EvacuationData = ...;

int demand[n in EvacuationData] = n.demand;

tuple PathNode {
 	key int id;
 	int tail; 
 	int head;
};
 
{PathNode} Paths[RPaths] = ...;
 
 tuple Edge {
  	key int tail; 
 	key int head;
	int capacity;
 };
 
{Edge} Edges = ...;

tuple PE {
	key int path;
	key int edge;
	int tail;
	int head;
};

{PE} pes; 


execute {
	for(var p in RPaths)
		for(var e in Paths[p])
		    pes.add(p,e.id,e.tail,e.head);	
}
{PE} startNodes = { e | e in pes : e.edge == 0 };

//last edge id for each path 
//int lastEdge[p in RPaths] = card(Paths[p]) - 1;

int maxFlow = max(e in Edges: e.tail >= startEvacuationNodes && e.tail <= endEvacuationNodes) e.capacity;
int horizon = sum(e in EvacuationData) e.demand;

//decision variables
dvar interval act[pes] in 0..horizon;
dvar int flow[pes] in 0..maxFlow;
   
//cumulative function 
cumulFunction edge[e in Edges] = sum(p in pes: p.tail == e.tail && p.head == e.head)
									pulse(act[p], 0, demand[<p.path-1>]);
   
//objective
//minimize max(p in RPaths, e in pes : e.path == p && e.edge == card(Paths[p]) - 1 )endOf(act[e]); 
minimize max(e in pes)endOf(act[e]); 

constraints{
  
  //flow 
  forall(p in pes)
   demand[<p.path-1>]<= flow[p]*sizeOf(act[p]);
  
  forall(e in Edges, p in pes : p.tail == e.tail && p.head == e.head)
    heightAtStart(act[p], edge[e]) == flow[p];
  
  forall(p in RPaths, p1 in pes, p2 in pes: p1.path == p && p2.path == p && p2.edge == p1.edge +1)
    flow[p1] == flow[p2];
    
  forall(p in RPaths, e in pes: e.path ==p )
    flow[e] <= demand[<e.path-1>];  
    
  //for any edge you cannot exceed capacity 
  forall(e in Edges)
    edge[e] <= e.capacity;
    
  //cannot stop at any edge 
  forall(p in RPaths, p1 in pes, p2 in pes: p1.path == p && p2.path == p && p2.edge == p1.edge +1)
    startOf(act[p2]) == startOf(act[p1]) + 1; 
  
  forall(p in RPaths, p1 in pes, p2 in pes: p1.path == p && p2.path == p && p2.edge == p1.edge +1)
    endOf(act[p2]) == endOf(act[p1]) + 1; 
   
  forall(p in RPaths, p1 in pes, p2 in pes: p1.path == p && p2.path == p && p2.edge == p1.edge +1)
    sizeOf(act[p2]) == sizeOf(act[p1]); 
    
  forall(e in startNodes, p in pes: e.path == p.path)
    startOf(act[p]) == p.edge + startOf(act[e]);
} 

