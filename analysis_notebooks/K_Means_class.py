import pandas as pd
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
        
class k_means():
    """
        General Info:
        This function takes in one input DataFrame and output three different DataFrames informing of any patterns
        we may see between the age groups and the Elixhauser categories as clusters. It is important to look carefully
        at your results as the clusters do not stay in one order when the class is ran. In other words, there is three
        clusters, one will contain all the dieases which have a higher prevalance in younger age groups than in older 
        age groups. Another will contains all the diseases which have a generally lower prevalence throughout
        all age groups (typically between 0% - 3%). The third will contain diseases that are more  prevalent with age. 
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
    
    def __init__(self, df):
        # Seperating into each group and dropping duplicates
        age_g1 = df[df.age_group == 1].drop_duplicates()
        age_g2 = df[df.age_group == 2].drop_duplicates()
        age_g3 = df[df.age_group == 3].drop_duplicates()
        age_g4 = df[df.age_group == 4].drop_duplicates()
        age_g5 = df[df.age_group == 5].drop_duplicates()

        # Data processing
        keep_g1 = age_g1.drop(columns = ['subject_id', 'hadm_id', 'subgroup', 'admission_type', 'age_group']).sum(axis = 1)
        keep_g2 = age_g2.drop(columns = ['subject_id', 'hadm_id', 'subgroup', 'admission_type', 'age_group']).sum(axis = 1)
        keep_g3 = age_g3.drop(columns = ['subject_id', 'hadm_id', 'subgroup', 'admission_type', 'age_group']).sum(axis = 1)
        keep_g4 = age_g4.drop(columns = ['subject_id', 'hadm_id', 'subgroup', 'admission_type', 'age_group']).sum(axis = 1)
        keep_g5 = age_g5.drop(columns = ['subject_id', 'hadm_id', 'subgroup', 'admission_type', 'age_group']).sum(axis = 1)

        # Calculating the disease prevalence for each group
        # Additional processing involved here
        prevalence_g5 = age_g5[keep_g5 >= 1].mean()[2:-3]
        prevalence_g4 = age_g4[keep_g4 >= 1].mean()[2:-3]
        prevalence_g3 = age_g3[keep_g3 >= 1].mean()[2:-3]
        prevalence_g2 = age_g2[keep_g2 >= 1].mean()[2:-3]
        prevalence_g1 = age_g1[keep_g1 >= 1].mean()[2:-3]

        # Combining all prevalances into single DataFrame
        self.all_prevalences = pd.DataFrame({'group_1' : prevalence_g1,
                  'group_2' : prevalence_g2,
                  'group_3' : prevalence_g3,
                  'group_4' : prevalence_g4,
                  'group_5' : prevalence_g5
                 }).reset_index()

        # Dropping index, don't need for fitting 
        all_prevalences_data = self.all_prevalences.drop('index', axis=1)

        # Standardizing data
        scaler = StandardScaler()
        data_standardized = scaler.fit_transform(all_prevalences_data)

        # Preforming k-means
        kmeans = KMeans(n_clusters=3)
        clusters = kmeans.fit_predict(data_standardized)
        self.all_prevalences['Cluster'] = kmeans.fit_predict(all_prevalences_data)

        # Result DataFrames
        self.res_cluster_0 = self.all_prevalences[self.all_prevalences.Cluster == 0]
        self.res_cluster_1 = self.all_prevalences[self.all_prevalences.Cluster == 1]
        self.res_cluster_2 = self.all_prevalences[self.all_prevalences.Cluster == 2]
        
    def cluster_0(self):
        return self.res_cluster_0
    
    def cluster_1(self):
        return self.res_cluster_1
    
    def cluster_2(self):
        return self.res_cluster_2





