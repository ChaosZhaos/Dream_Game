// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Triplebrick/OverlayStandard"
{
	Properties
	{
		_Basecolor1("Basecolor 1", 2D) = "white" {}
		_Normal1("Normal 1", 2D) = "bump" {}
		_Normal1Scale("Normal 1 Scale", Range( 0 , 1)) = 0
		_BaseOffset("Base Offset", Vector) = (0,0,0,0)
		_BaseTiling("Base Tiling", Vector) = (1,1,0,0)
		_Basecolor2("Basecolor 2", 2D) = "white" {}
		_Normal2("Normal 2", 2D) = "bump" {}
		_BasecolorOverlay("Basecolor Overlay", 2D) = "white" {}
		_NormalOverlay("Normal Overlay", 2D) = "bump" {}
		[Toggle]_EnableDirtOverlay("Enable Dirt Overlay", Float) = 0
		_DirtOverlay("Dirt Overlay", 2D) = "gray" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Normal1Scale;
		uniform sampler2D _Normal1;
		uniform float2 _BaseTiling;
		uniform float2 _BaseOffset;
		uniform sampler2D _NormalOverlay;
		uniform float4 _NormalOverlay_ST;
		uniform sampler2D _Normal2;
		uniform sampler2D _BasecolorOverlay;
		uniform float4 _BasecolorOverlay_ST;
		uniform float _EnableDirtOverlay;
		uniform sampler2D _Basecolor1;
		uniform sampler2D _Basecolor2;
		uniform sampler2D _DirtOverlay;
		uniform float4 _DirtOverlay_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord59 = i.uv_texcoord * _BaseTiling + _BaseOffset;
			float2 uv_NormalOverlay = i.uv_texcoord * _NormalOverlay_ST.xy + _NormalOverlay_ST.zw;
			float2 uv_BasecolorOverlay = i.uv_texcoord * _BasecolorOverlay_ST.xy + _BasecolorOverlay_ST.zw;
			float4 tex2DNode49 = tex2D( _BasecolorOverlay, uv_BasecolorOverlay );
			float3 lerpResult45 = lerp( BlendNormals( UnpackScaleNormal( tex2D( _Normal1, uv_TexCoord59 ) ,_Normal1Scale ) , UnpackNormal( tex2D( _NormalOverlay, uv_NormalOverlay ) ) ) , UnpackNormal( tex2D( _Normal2, uv_TexCoord59 ) ) , ( 1.0 * tex2DNode49.a ));
			o.Normal = lerpResult45;
			float4 tex2DNode40 = tex2D( _Basecolor1, uv_TexCoord59 );
			float4 blendOpSrc51 = tex2DNode40;
			float4 blendOpDest51 = tex2DNode49;
			float4 tex2DNode41 = tex2D( _Basecolor2, uv_TexCoord59 );
			float4 lerpResult42 = lerp( ( saturate( (( blendOpDest51 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest51 - 0.5 ) ) * ( 1.0 - blendOpSrc51 ) ) : ( 2.0 * blendOpDest51 * blendOpSrc51 ) ) )) , tex2DNode41 , tex2DNode49.a);
			float2 uv_DirtOverlay = i.uv_texcoord * _DirtOverlay_ST.xy + _DirtOverlay_ST.zw;
			float4 blendOpSrc65 = lerpResult42;
			float4 blendOpDest65 = tex2D( _DirtOverlay, uv_DirtOverlay );
			o.Albedo = lerp(lerpResult42,( saturate( (( blendOpDest65 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest65 - 0.5 ) ) * ( 1.0 - blendOpSrc65 ) ) : ( 2.0 * blendOpDest65 * blendOpSrc65 ) ) )),_EnableDirtOverlay).rgb;
			float lerpResult46 = lerp( tex2DNode40.a , tex2DNode41.a , tex2DNode49.a);
			o.Smoothness = lerpResult46;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	
}
/*ASEBEGIN
Version=15301
8;100;1060;789;1255.537;188.5014;1.529858;True;False
Node;AmplifyShaderEditor.Vector2Node;61;-1797.307,-187.4905;Float;False;Property;_BaseOffset;Base Offset;3;0;Create;True;0;0;False;0;0,0;0.14,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;60;-1791.279,-316.3055;Float;False;Property;_BaseTiling;Base Tiling;4;0;Create;True;0;0;False;0;1,1;2,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-1440.142,-326.9963;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;40;-1059.89,-590.9361;Float;True;Property;_Basecolor1;Basecolor 1;0;0;Create;True;0;0;False;0;None;07f8e1e190317db45b10aa82021ae85d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;49;-1022.829,580.6707;Float;True;Property;_BasecolorOverlay;Basecolor Overlay;7;0;Create;True;0;0;False;0;None;e15071f89a7ae064d8ed131c3d50c857;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;52;-1295.854,238.4618;Float;False;Property;_Normal1Scale;Normal 1 Scale;2;0;Create;True;0;0;False;0;0;0.834;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;51;-680.0574,-483.295;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;41;-1037.479,-201.2945;Float;True;Property;_Basecolor2;Basecolor 2;5;0;Create;True;0;0;False;0;None;7f0c2d59c85c3aa40a28c6f5c35035fa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;43;-1011.158,132.2406;Float;True;Property;_Normal1;Normal 1;1;0;Create;True;0;0;False;0;None;fa1041d6612a713478fa6d8ddfe74e30;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;48;-1008.314,818.6196;Float;True;Property;_NormalOverlay;Normal Overlay;8;0;Create;True;0;0;False;0;None;9b36fecee576f804aa366861065bd0af;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;42;-436.9529,-269.0194;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;66;-267.9615,-654.0313;Float;True;Property;_DirtOverlay;Dirt Overlay;10;0;Create;True;0;0;False;0;None;None;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;47;-1012.375,350.6762;Float;True;Property;_Normal2;Normal 2;6;0;Create;True;0;0;False;0;None;9fa3fd450af6fdf4689b5cc37418311e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;65;65.06569,-394.6213;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;50;-513.6521,158.5881;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-488.8629,504.6154;Float;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;45;-142.9277,315.1629;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;46;-432.248,-135.2492;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;67;195.1123,-192.3357;Float;False;Property;_EnableDirtOverlay;Enable Dirt Overlay;9;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;405.3199,0.4476863;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Triplebrick/OverlayStandard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;59;0;60;0
WireConnection;59;1;61;0
WireConnection;40;1;59;0
WireConnection;51;0;40;0
WireConnection;51;1;49;0
WireConnection;41;1;59;0
WireConnection;43;1;59;0
WireConnection;43;5;52;0
WireConnection;42;0;51;0
WireConnection;42;1;41;0
WireConnection;42;2;49;4
WireConnection;47;1;59;0
WireConnection;65;0;42;0
WireConnection;65;1;66;0
WireConnection;50;0;43;0
WireConnection;50;1;48;0
WireConnection;68;1;49;4
WireConnection;45;0;50;0
WireConnection;45;1;47;0
WireConnection;45;2;68;0
WireConnection;46;0;40;4
WireConnection;46;1;41;4
WireConnection;46;2;49;4
WireConnection;67;0;42;0
WireConnection;67;1;65;0
WireConnection;0;0;67;0
WireConnection;0;1;45;0
WireConnection;0;4;46;0
ASEEND*/
//CHKSM=EFCB73B9E55F6F5AB15801E5AF61C2EC9300EAB1