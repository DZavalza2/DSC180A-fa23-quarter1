import pandas as pd
import numpy as np
import networkx as nx
import matplotlib.pyplot as plt
    
def network_analysis(df):
    """
        General Info:
        This function takes in one input DataFrame and output a network graph. The newtork graph uses Relative Risk in order
        to calculate the prevalence given two different dieases. In the result, the node size is based on the number of patients
        with that specific disease in that age group. The edge width represents the relative risk. T
        ------------------

        Input:
        df: DataFrame containing data on each patients Elixhauser categories and their age_group. It is important that
            the input DataFrame follows the exact structure as below in terms of order and data types as not following
            this may cause an error in the code. 

            Columns | Datatype
            'subject_id' : str
            'hadm_id' : str
            'congestive_heart_failure' : int (0 or 1)
            'cardiac_arrhythmias' : int (0 or 1)
            'valvular_disease' : int (0 or 1)
            'pulmonary_circulation' : int (0 or 1)
            'peripheral_vascular' : int (0 or 1)
            'hypertension' : int (0 or 1)
            'paralysis' : int (0 or 1)
            'other_neurological' : int (0 or 1)
            'chronic_pulmonary' : int (0 or 1)
            'diabetes_uncomplicated' : int (0 or 1)
            'diabetes_complicated' : int (0 or 1)
            'hypothyroidism' : int (0 or 1)
            'renal_failure' : int (0 or 1)
            'liver_disease' : int (0 or 1)
            'peptic_ulcer' : int (0 or 1)
            'aids' : int (0 or 1)
            'lymphoma' : int (0 or 1)
            'metastatic_cancer' : int (0 or 1)
            'solid_tumor' : int (0 or 1)
            'rheumatoid_arthritis' : int (0 or 1)
            'coagulopathy' : int (0 or 1)
            'obesity' : int (0 or 1)
            'weight_loss' : int (0 or 1)
            'fluid_electrolyte' : int (0 or 1)
            'blood_loss_anemia' : int (0 or 1)
            'deficiency_anemias' : int (0 or 1)
            'alcohol_abuse' : int (0 or 1)
            'drug_abuse' : int (0 or 1)
            'psychoses' : int (0 or 1)
            'depression' : int (0 or 1)
            'age_group': int (1 - 5)
            'admission_type' : int (0 or 1)
            'subgroup' : int (1 - 6)
        """
    ## RR Setup
    no_dups = df.drop_duplicates()
    only_diseases = no_dups.drop(columns = ['subject_id', 'hadm_id', 'admission_type', 'subgroup', 'age_group']) # df with only dieases columns
    only_shape = only_diseases.shape[1] # number of patients in specific group

    # RR
    weighted_adjacency = np.zeros((only_shape, only_shape))
    disease_columns = only_diseases.columns
    for i in range(1, only_shape + 1):
        for j in range(i+1, only_shape):
            disease_pair_weight = 0
            disease_pair_weight += only_diseases.iloc[:, i].sum() # count of first disease
            disease_pair_weight += only_diseases.iloc[:, j].sum() # count of second disease
            disease_pair_weight /= only_shape # divide by total number of people in subgroup
            weighted_adjacency[i, j] = disease_pair_weight
            weighted_adjacency[j, i] = disease_pair_weight

    G = nx.Graph() # Initialize graph
    for disease in only_diseases.columns:
        node_size = no_dups[disease].sum() # find node size of each disease
        G.add_node(disease, size = node_size) # add the node based on size

    # add edges for each disease
    for i in range(30):
        for j in range(30):
            (
                G.add_edge(
                    only_diseases.iloc[:,i].name, 
                    only_diseases.iloc[:,j].name, 
                    weight = weighted_adjacency[i][j])
            )

    # Increase node sizes, not very visible    
    node_sizes = np.array([])
    for n in G.nodes:
        node_sizes = np.append(node_sizes, G.nodes[n]['size'] * 100 )

    # Extract edge weights from edge attributes
    edge_weights = np.array([])
    for e in G.edges:   
        edge_weights = np.append(edge_weights, G[e[0]][e[1]]['weight'])  

    # normalize weights
    normalized_weights = [(weight - min(edge_weights)) / (max(edge_weights) - min(edge_weights)) for weight in edge_weights]

    # Map nodes and edges
    plt.figure(figsize=(12, 12))
    pos = nx.circular_layout(G)
    nx.draw_networkx_nodes(G, pos, node_size=node_sizes, node_color='blue', alpha=1)
    nx.draw_networkx_edges(G, pos, width=np.array(normalized_weights) * 2, edge_color='black', alpha=.25)

    labels = {n: n for n in G.nodes}
    nx.draw_networkx_labels(G, pos, labels=labels, font_size=10)
    plt.axis('off')
    plt.show()