#Retrieve the Patient_id and ages of all patients.
SELECT Patient_id, age
FROM internproject.diabetes_prediction;

#Select all female patients who are older than 40.
SELECT *
FROM internproject.diabetes_prediction
WHERE gender = 'Female' AND age > 40;

#Calculate the average BMI of patients.
SELECT avg(bmi) as AverageBMI
FROM internproject.diabetes_prediction;



#List patients in descending order of blood glucose levels
SELECT *
FROM internProject.diabetes_Prediction
ORDER BY blood_glucose_level DESC;


#Find patients who have hypertension and diabetes.
SELECT *
FROM internproject.diabetes_prediction
WHERE hypertension = True AND diabetes = True;

#Determine the number of patients with heart disease.
SELECT COUNT(heart_disease) as HeartDisease
FROM internproject.diabetes_prediction
WHERE heart_disease = True;


#Group patients by smoking history and count how many smokers and non-smokers there are.
SELECT smoking_history,count(smoking_history) AS HistoryOFsmoking
FROM internproject.diabetes_prediction
GROUP BY smoking_history;
SELECT smoking_history,count(smoking_history) AS NumberOfSmokers
FROM internproject.diabetes_prediction
WHERE smoking_history = 'Current' OR 
smoking_history = 'never'
GROUP BY smoking_history;

#Retrieve the Patient_ids of patients who have a BMI greater than the average BMI.
SELECT Patient_id
FROM internproject.diabetes_prediction
WHERE bmi > (SELECT avg(bmi) from internproject.diabetes_prediction);


#Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel
SELECT *
FROM internproject.diabetes_prediction
WHERE HbA1c_level = (SELECT MAX(HbA1c_level) from internproject.diabetes_prediction)
OR HbA1c_level = (SELECT MIN(HbA1c_level) from internproject.diabetes_prediction)
ORDER BY HbA1c_level DESC;


#Calculate the age of patients in years (assuming the current date as of now).
SELECT EmployeeName,Patient_id,gender,age, (2023 - age) AS YearOfBirth
FROM internproject.diabetes_prediction;



#Rank patients by blood glucose level within each gender group.
SELECT *, rank() OVER (partition by gender order by blood_glucose_level) AS RankOfPatient
FROM internproject.diabetes_prediction;

#Update the smoking history of patients who are older than 50 to "Ex-smoker."
update internproject.diabetes_prediction
SET smoking_history = 'Ex-Smoker'
WHERE age > 50;

SELECT EmployeeName, gender,age,smoking_history
FROM internproject.diabetes_prediction
WHERE age > 50;

#Insert a new patient into the database with sample data.
INSERT INTO internproject.diabetes_prediction VALUES(
'Lionel Messi' ,2001 ,'Male', 34, 0, 0, 'never', 10.5, 4, 90, 0
);
SELECT * FROM internproject.diabetes_prediction
WHERE EmployeeName like '%lionel messi%';

#Delete all patients with heart disease from the database.
delete FROM internproject.diabetes_prediction
WHERE heart_disease = True;

SELECT * FROM internproject.diabetes_prediction
WHERE heart_disease = True;


#Find patients who have hypertension but not diabetes using the EXCEPT operator
SELECT Patient_id,hypertension, diabetes
FROM internproject.diabetes_prediction
where hypertension = True
EXCEPT
SELECT Patient_id, hypertension, diabetes
FROM internproject.diabetes_prediction
WHERE diabetes = True;

#Define a unique constraint on the "patient_id" column to ensure its values are unique.
ALTER TABLE internproject.diabetes_prediction
ADD constraint unique_patient_id unique (Patient_id(20));

#Create a view that displays the Patient_ids, ages, and BMI of patients.
create view internproject.PatientBmi as
SELECT Patient_id, age, bmi
FROM internproject.diabetes_prediction;

SELECT * FROM internproject.patientbmi





