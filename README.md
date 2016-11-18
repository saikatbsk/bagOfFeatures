## Image Classification Using Bag of Features

Image classification using the Bag-of-Features model. Speeded-Up Robust Features (SURF) extracted from natural images are clustered and then quantized to create vector representations of training images. Feature vectors are extended to account for spatial information. Classification using a Support Vector Machine (SVM).

- Tested with [GNU Octave (4.0.2)](https://www.gnu.org/software/octave/).
- Looking for MATLAB version? [available here](https://github.com/saikatbsk/daily-dose-of-code/tree/master/MachineLearning/02_BoF)

#### Instructions

- Download image dataset from here: https://www.vision.caltech.edu/Image_Datasets/Caltech101/
- Edit `main.m` and change the `dataset_root` variable.
- Run `main` to train and test the system. Displays the confusion matrix and average accuracy.
- Run `test` to test with individual files.

#### Expected Results
![alt text](img/01.png)

#### Licenses
- **OpenSURF version 1c** includes its own license.
- Rest of the code is under **GNU GPL v3**. Read `license.txt` for details.
