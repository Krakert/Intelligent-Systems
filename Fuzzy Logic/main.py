import numpy as np
import skfuzzy as fuzz
from skfuzzy import control as ctrl

# New Antecedent/Consequent objects hold universe variables and membership
# functions
quality = ctrl.Antecedent(np.arange(0, 11, 1), 'quality')
service = ctrl.Antecedent(np.arange(0, 11, 1), 'service')
tip = ctrl.Consequent(np.arange(0, 26, 1), 'tip')

quality['Bad'] = fuzz.trimf(quality.universe, [0, 0, 5])
quality['Oke'] = fuzz.trimf(quality.universe, [0, 5, 10])
quality['Great'] = fuzz.trimf(quality.universe, [5, 10, 10])

service['Bad'] = fuzz.trimf(service.universe, [0, 0, 5])
service['Oke'] = fuzz.trimf(service.universe, [0, 5, 10])
service['Great'] = fuzz.trimf(service.universe, [5, 10, 10])

# service['Bad'] = fuzz.trimf(service.universe, [0, 0, 5])
# service['Oke'] = fuzz.trimf(service.universe, [3, 6, 9])
# service['Great'] = fuzz.trimf(service.universe, [7, 10, 10])

# Custom membership functions can be built interactively with a familiar,
# Pythonic API
tip['Small'] = fuzz.trimf(tip.universe, [0, 0, 13])
tip['Average'] = fuzz.trimf(tip.universe, [0, 13, 25])
tip['High'] = fuzz.trimf(tip.universe, [13, 25, 25])

# quality.view()
# service.view()
# tip.view()

rule1 = ctrl.Rule(quality['Bad'] | service['Bad'], tip['Small'])
rule2 = ctrl.Rule(service['Oke'], tip['Average'])
rule3 = ctrl.Rule(service['Great'] | quality['Great'], tip['High'])

# allBad = ctrl.Rule(quality['Bad'] & service['Bad'], tip['Small'])
# allOke = ctrl.Rule(quality['Oke'] & service['Oke'], tip['Average'])
# allGreat = ctrl.Rule(quality['Great'] & service['Great'], tip['High'])
#
# foodBad = ctrl.Rule(quality['Bad'], tip['Small'])
# foodOke = ctrl.Rule(quality['Oke'], tip['Average'])
# foodGreat = ctrl.Rule(quality['Great'], tip['High'])
#
# serviceBad = ctrl.Rule(service['Bad'], tip['Small'])
# serviceOke = ctrl.Rule(service['Oke'], tip['Average'])
# serviceGreat = ctrl.Rule(service['Great'], tip['Average'])

# tipping_ctrl = ctrl.ControlSystem([
#     allBad, allOke, allGreat,
#     foodBad, foodOke, foodGreat,
#     serviceBad, serviceOke, serviceGreat])

tipping_ctrl = ctrl.ControlSystem([rule1, rule2, rule3])

tipJan = ctrl.ControlSystemSimulation(tipping_ctrl)
tipMats = ctrl.ControlSystemSimulation(tipping_ctrl)

# Input of Jan
tipJan.input['service'] = 9.8
tipJan.input['quality'] = 8.8

# Calculate tip for Jan
tipJan.compute()

# Print % of tip for Jan
print(tipJan.output['tip'])

# View result for Jan
tip.view(sim=tipJan)

# Input of Mats
tipMats.input['service'] = 5.8
tipMats.input['quality'] = 7.8

# Do the same for Mats
tipMats.compute()
print(tipMats.output['tip'])
tip.view(sim=tipMats)
