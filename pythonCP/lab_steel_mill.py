#-----------------------------------------------------------------------------
# Steel Mill Slab Project
# Fill in the blanks :)
#-----------------------------------------------------------------------------

from docplex.cp.model import CpoModel
from collections import namedtuple

#-----------------------------------------------------------------------------
# Initialize the problem data
#-----------------------------------------------------------------------------

# List of coils to produce (orders)
Order = namedtuple("Order", ['id', 'weight', 'color'])
ORDERS = (
   Order(1,4,1),
   Order(2,22,2),
   Order(3,9,3),
   Order(4,5,4),
   Order(5,8,5),
   Order(6,3,6),
   Order(7,3,4),
   Order(8,4,7),
   Order(9,7,4),
   Order(10,7,8),
   Order(11,3,6),
   Order(12,2,6),
   Order(13,2,4),
   Order(14,8,9),
   Order(15,5,10),
   Order(16,7,11),
   Order(17,4,7),
   Order(18,7,11),
   Order(19,5,10),
   Order(20,7,11),
   Order(21,8,9),
   Order(22,3,1),
   Order(23,25,12),
   Order(24,14,13),
   Order(25,3,6),
   Order(26,22,14),
   Order(27,19,15),
   Order(28,19,15),
   Order(29,22,16),
   Order(30,22,17),
   Order(31,22,18),
   Order(31,20,19),
   Order(33,22,20),
   Order(34,5,21),
   Order(35,4,22),
   Order(36,10,23),
   Order(37,26,24),
   Order(38,17,25),
   Order(39,20,26),
   Order(40,16,27),
   Order(41,10,28),
   Order(42,19,29),
   Order(43,10,30),
   Order(44,10,31),
   Order(45,23,32),
   Order(46,22,33),
   Order(47,26,34),
   Order(48,27,35),
   Order(49,22,36),
   Order(50,27,37),
   Order(51,22,38),
   Order(52,22,39),
   Order(53,13,40),
   Order(54,14,41),
   Order(55,16,27),	
   Order(56,26,34),
   Order(57,26,42),
   Order(58,27,35),
   Order(59,22,36),
   Order(60,20,43),
   Order(61,26,24),	
   Order(62,22,44),
   Order(63,13,45),
   Order(64,19,46),
   Order(65,20,47),
   Order(66,16,48),
   Order(67,15,49),
   Order(68,17,50),
   Order(69,10,28),	
   Order(70,20,51),	
   Order(71,5,52),
   Order(72,26,24),	
   Order(73,19,53),
   Order(74,15,54),
   Order(75,10,55),
   Order(76,10,56),
   Order(77,13,57),
   Order(78,13,58),
   Order(79,13,59),
   Order(80,12,60),
   Order(81,12,61),
   Order(82,18,62),
   Order(83,10,63),
   Order(84,18,64),
   Order(85,16,65),
   Order(86,20,66),
   Order(87,12,67),
   Order(88,6,68),
   Order(89,6,68),
   Order(90,15,69),
   Order(91,15,70),
   Order(92,15,70),
   Order(93,21,71),
   Order(94,30,72),
   Order(95,30,73),
   Order(96,30,74),
   Order(97,30,75),
   Order(98,23,76),
   Order(99,15,77),
   Order(100,15,78),
   Order(101,27,79),
   Order(102,27,80),
   Order(103,27,81),
   Order(104,27,82),
   Order(105,27,83),
   Order(106,27,84),
   Order(107,27,79),
   Order(108,27,85),
   Order(109,27,86),
   Order(110,10,87),
   Order(111,3,88)
)

# Max number of different colors of coils produced by a single slab
MAX_COLOR_PER_SLAB = 2

# List of available slab weights.
capacities = [12, 14, 17, 18, 19, 20, 23, 24, 25, 26, 27, 28, 29, 30, 32, 35, 39, 42, 43, 44]


#-----------------------------------------------------------------------------
# Prepare the data for modeling
#-----------------------------------------------------------------------------

# Upper bound for the number of slabs to use
MAX_SLABS = len(ORDERS)
Slabs = range(MAX_SLABS)

# Build a set of all colors
allcolors = set(o.color for o in ORDERS)

# Build an array of weights
allweights =  list(o.weight for o in ORDERS)

# The heaviest slab
max_slab_weight = max(capacities)

# Minimum loss incurred for a given slab usage.
# loss[v] = loss when smallest slab is used to produce a total weight of v
loss = [0] + [min([sw - v for sw in capacities if sw >= v]) for v in range(1, max_slab_weight + 1)]

#-----------------------------------------------------------------------------
# Build the model
#-----------------------------------------------------------------------------

# Create model 
mdl = CpoModel()

# Index of the slab used to produce each coil order
slab = mdl.integer_var_list(len(ORDERS), 0, MAX_SLABS-1, "slab")

# Usage of each slab
load = mdl.integer_var_list(MAX_SLABS, 0, max_slab_weight, "load")

# The orders are allocated to the slabs and the load of slab is computed
mdl.pack(load,slab,allweights)

# Constrains the maximum number of colors produced by each slab
for s in Slabs:
  mdl.add(sum(mdl.logical_or(slab[o.id - 1]==s for o in ORDERS if o.color == c) for c in allcolors)<=2)

# Minimize the total loss
mdl.minimize(sum(mdl.element(load[s],loss) for s in Slabs))

# Set search strategy
mdl.set_search_phases([mdl.search_phase(slab)])

#-----------------------------------------------------------------------------
# Solve the model 
#-----------------------------------------------------------------------------

# Solve model
print("Solving model....")
msol = mdl.solve()

  




    
    



