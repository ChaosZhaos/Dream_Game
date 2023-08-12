Thank you for purchasing The Dark Dungeon Kit. I hope you like it and it fits your needs.

Please use the following project settings when using The Dark Dungeon Kit

BuiltIn RP
Edit->Project Settings->Player->Other Settings/Rendering
Set the Color Space to "Linear"
Edit->Project Settings->Graphics->Tier Settings
Set the Rendering Path to "Deferred"
To achieve the same visuals as shown in the screenshots install the Post Processing stack via the Windows->Packet Manager. 
Follow the Unity docs to set up the Postprocessing stack.
You find the according profiles under RenderPipelines/BuiltIn/*

URP
Import the package into a new URP Unity project.
Double-click the RenderPipelines/URP package.
Create a Global Volume in the Hierarchy Window. Assing the provided Profiles to be found in the folder RenderPipelines/URP/ 
Enable the Postprocessing checkbox in the Main Camera (Hierarchy Window MotionController/FPC/Camera)

HDRP
Import the package into a new HDRP Unity project.
Double-click the RenderPipelines/HDRP package.
Create a Global Volume in the Hierarchy Window. Assing the provided Profiles to be found in the folder RenderPipelines/HDRP/ 

Best regards
TripleBrick