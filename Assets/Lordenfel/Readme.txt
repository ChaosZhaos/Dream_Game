Thank you for purchasing Lordenfel!

Setting Up Your Project
For best results:
Make sure you are using Linear color space (Edit -> Project Settings -> Player -> Other Settings -> Color space).
Install Post Process and Polybrush packs from Package Manager.

Baked lighting is setup and tested with lightmap Resolution of 12, but you can use other values if you like.

"Generate Lightmap UVs" is turned off for source fbx files to reduce import times,
but the settings are saved. You can simply turn it back on and it will work.
(open Assets\Lordenfel\Source in Unity, select files, check Generate Lightmap UVs in the Inspector)

Installation
For Built-in workflow:
Double click on “Lordenfel_Built-In_2019.4.3” to unpack the file into your current project.
Open Window -> Package Manager, search and install Post Processing.

For HDRP:
Make sure you have High Definition RP installed from Package Manager
Unpack “Lordenfel_HDRP_2019.4.3”
For new projects - assign the file Lordenfel/HDRPAssets/LRD HDRenderPipelineAsset to
Edit -> Project Settings -> Graphics -> Scriptable Render Pipeline Settings field

For URP:
Make sure you have Universal RP installed from Package Manager
Unpack “Lordenfel_URP_2019.4.3”
For new projects - assign the file Lordenfel/URPAssets/LRD UniversalRenderPipelineAsset to
Edit -> Project Settings -> Graphics -> Scriptable Render Pipeline Settings field

Troubleshooting:
The grass is neon green in HDRP. Fix: select the object's material, click "Fix" in the warning message under the "Diffusion Profile" field.
Everything is green or glowing in HDRP. Fix: click Play once and it will fix itself.
It looks dull and gray. Fix: make sure you are using Linear color space.

Please feel free to email us at manastation3d@gmail.com if you have questions or comments.
