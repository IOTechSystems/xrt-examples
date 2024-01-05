max_values = [10, 20, 30]  # Maximum values for each resource
directions = [True, True, True]  # Initial directions for increase (True for increasing)
steps = [1, 2, 3]  # Step size for each resource


def update_values(resources):
    print("--==-- UPDATE --==--")
    resource1 = resources["cell_1_tmp"]
    resource2 = resources["cell_2_tmp"]
    resource3 = resources["cell_3_tmp"]
    
    sf = (resources["tmp_sf"]).get_value()
    
    old_val = resource1.get_value()
    new_val = (old_val + 1)
    print("Read in cell_1_tmp : ",old_val)
    resource1.set_value(new_val)
    print("Increment by 1 and write to cell_1_tmp : ",new_val)

    new_val = old_val*sf
    resource2.set_value(new_val)
    print("Multiply cell_1_tmp by SF and write to cell_2_tmp : ",new_val)

    new_val = old_val*sf
    resource3.set_value(new_val)
    print("Multiply cell_1_tmp by SF and write to cell_3_tmp : ",new_val)

