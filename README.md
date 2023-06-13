# This is the modified version of open-mmlab/playground

### Compare to original
Fix RAM issue
- The original version will not release RAM and keep load SAM model to new instance for every image
- The backend will be OOM after a few image and killed
Faster labeling
- Due to the RAM issue, the labeling process take way too long
- Improve the load time on image load to < 1s
- Improve SAM labeling result draw to < 1s
 

### Environment
```
conda create -n rtmdet-sam python=3.9 -y
conda activate rtmdet-sam
```
### Install torch with appropriate CUDA version
```
# Linux and Windows CUDA 11.3
pip install torch==1.10.1+cu113 torchvision==0.11.2+cu113 torchaudio==0.10.1 -f https://download.pytorch.org/whl/cu113/torch_stable.html


# Linux and Windows CPU only
pip install torch==1.10.1+cpu torchvision==0.11.2+cpu torchaudio==0.10.1 -f https://download.pytorch.org/whl/cpu/torch_stable.html

# OSX
pip install torch==1.10.1 torchvision==0.11.2 torchaudio==0.10.1

```
### Install SAM
```
pip install opencv-python pycocotools matplotlib onnxruntime onnx
pip install git+https://github.com/facebookresearch/segment-anything.git

# download SAM h model (better result)
wget https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth

```

### Install Label Studio
```
# sudo apt install libpq-dev python3-dev # Note: If using Label Studio 1.7.2 version, you need to install libpq-dev and python3-dev dependencies.

# Installing label-studio may take some time. If you cannot find the version, please use the official source.
pip install label-studio==1.7.3
pip install label-studio-ml==1.0.9
```

### Start Label studio
```
# Start label studio web
start-label.sh

# Start label studio ml backend
# set out_mask=False  out_poly=True to get polygons results
# set out_mask=True  out_poly=False to get masks results
start-ml.sh
```

### Configure labeling inference
Label name need to be the same for every label type
SAM use keypoints and rectangle labels as input, PolygonLabels and BrushLabels to draw results

```xml
<View>
  <Image name="image" value="$image" zoom="true"/>
  <KeyPointLabels name="KeyPointLabels" toName="image">
  </KeyPointLabels>
  <RectangleLabels name="RectangleLabels" toName="image">
    <Label value="label 1" background="#8BACAA"/>
  </RectangleLabels>
  <PolygonLabels name="PolygonLabels" toName="image" opacity="0.9">
    <Label value="label 1" background="#8BACAA"/>  </PolygonLabels>
  <BrushLabels name="BrushLabels" toName="image">
    <Label value="label 1" background="#8BACAA"/>
  </BrushLabels>
</View>

```
In the above XML, we have configured the annotations, where KeyPointLabels are for keypoint annotations, BrushLabels are for Mask annotations, PolygonLabels are for bounding polygon annotations, and RectangleLabels are for rectangle annotations. 

This example uses two categories, cat and person. If community users want to add more categories, they need to add the corresponding categories in KeyPointLabels, BrushLabels, PolygonLabels, and RectangleLabels respectively.

Next, copy and add the above XML to Label-Studio, and then click Save.

![image](https://user-images.githubusercontent.com/25839884/233832662-02f856e5-48e7-4200-9011-17693fc2e916.png)


After that, go to Settings and click Add Model to add the OpenMMLabPlayGround backend inference service. Set the URL http://localhost:8003 for the SAM backend inference service, enable Use for interactive preannotations, and click Validate and Save.

⚠If you are unable to execute successfully at this step, probably due to the long model loading time, which causes the connection to the backend to time out, please re-execute `export ML_TIMEOUT_SETUP=40` (linux) or `set ML_TIMEOUT_SETUP=40` (windows) and restart the `label-studio start` SAM backend reasoning service.

![image](https://user-images.githubusercontent.com/25839884/233836727-568d56e3-3b32-4599-b0a8-c20f18479a6a.png)

If you see "Connected" as shown below, it means that the backend inference service has been successfully added.

![image](https://user-images.githubusercontent.com/25839884/233832884-1b282d1f-1f43-474b-b41d-de41ad248476.png)

## Start semi-automated annotation.

Click on Label to start annotating.

![image](https://user-images.githubusercontent.com/25839884/233833125-fd372b0d-5f3b-49f4-bcf9-e89971639fd5.png)

To use this feature, enable the Auto-Annotation toggle and it is recommended to check the Auto accept annotation suggestions option. Then click the Smart tool on the right side, switch to Point mode, and select the object label you want to annotate from the options below, in this case, choose "cat." If using Bbox2Label, please switch the Smart tool to Rectangle mode instead.

![image](https://user-images.githubusercontent.com/25839884/233833200-a44c9c5f-66a8-491a-b268-ecfb6acd5284.png)


Point2Label: As can be seen from the following gif animation, by simply clicking a point on the object, the SAM algorithm is able to segment and detect the entire object.

![SAM8](https://user-images.githubusercontent.com/25839884/233835410-29896554-963a-42c3-a523-3b1226de59b6.gif)


Bbox2Label: As can be seen from the following gif animation, by simply annotating a bounding box, the SAM algorithm is able to segment and detect the entire object.

![SAM10](https://user-images.githubusercontent.com/25839884/233969712-0d9d6f0a-70b0-4b3e-b054-13eda037fb20.gif)
