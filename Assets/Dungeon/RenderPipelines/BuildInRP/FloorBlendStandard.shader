// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Triplebrick/FloorBlendStandard"
{
	Properties
	{
		[NoScaleOffset]_BaseColorA("Base Color A", 2D) = "white" {}
		[NoScaleOffset]_NormalA("Normal A", 2D) = "white" {}
		_NormalAScale("Normal A Scale", Range( 0 , 1)) = 1
		[NoScaleOffset]_BaseColorB("BaseColor B", 2D) = "white" {}
		[NoScaleOffset]_NormalB("Normal B", 2D) = "white" {}
		_NormalBScale("Normal B Scale", Range( 0 , 1)) = 1
		_HeightRMasksGBAOA("Height(R) Masks(G+B) AO(A)", 2D) = "white" {}
		_WaterColor("Water Color", Color) = (0.3161765,0.2515303,0.1697124,0)
		_OcclusionStrength("Occlusion Strength", Range( 0 , 1)) = 0
		_WetEdges("Wet Edges", Range( 0.15 , 3)) = 0.15
		_WaterOpacity("Water Opacity", Range( 0 , 0.2)) = 0
		[HideInInspector]_TextureSample1("Texture Sample 1", 2D) = "bump" {}
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

		uniform float _NormalBScale;
		uniform sampler2D _NormalB;
		uniform float _NormalAScale;
		uniform sampler2D _NormalA;
		uniform sampler2D _HeightRMasksGBAOA;
		uniform float4 _HeightRMasksGBAOA_ST;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _WetEdges;
		uniform sampler2D _BaseColorB;
		uniform sampler2D _BaseColorA;
		uniform float4 _WaterColor;
		uniform float _WaterOpacity;
		uniform float _OcclusionStrength;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalB4 = i.uv_texcoord;
			float2 uv_NormalA3 = i.uv_texcoord;
			float2 uv_HeightRMasksGBAOA = i.uv_texcoord * _HeightRMasksGBAOA_ST.xy + _HeightRMasksGBAOA_ST.zw;
			float4 tex2DNode30 = tex2D( _HeightRMasksGBAOA, uv_HeightRMasksGBAOA );
			float3 lerpResult7 = lerp( UnpackScaleNormal( tex2D( _NormalB, uv_NormalB4 ) ,_NormalBScale ) , UnpackScaleNormal( tex2D( _NormalA, uv_NormalA3 ) ,_NormalAScale ) , tex2DNode30.g);
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float temp_output_60_0 = ( pow( tex2DNode30.b , _WetEdges ) * 1.0 );
			float3 lerpResult50 = lerp( lerpResult7 , UnpackNormal( tex2D( _TextureSample1, uv_TextureSample1 ) ) , temp_output_60_0);
			o.Normal = lerpResult50;
			float2 uv_BaseColorB2 = i.uv_texcoord;
			float4 tex2DNode2 = tex2D( _BaseColorB, uv_BaseColorB2 );
			float2 uv_BaseColorA1 = i.uv_texcoord;
			float4 tex2DNode1 = tex2D( _BaseColorA, uv_BaseColorA1 );
			float4 lerpResult6 = lerp( tex2DNode2 , tex2DNode1 , tex2DNode30.g);
			float4 lerpResult45 = lerp( lerpResult6 , _WaterColor , ( _WaterOpacity + temp_output_60_0 ));
			o.Albedo = lerpResult45.rgb;
			float lerpResult8 = lerp( tex2DNode2.a , tex2DNode1.a , tex2DNode30.g);
			float lerpResult48 = lerp( lerpResult8 , 0.98 , temp_output_60_0);
			o.Smoothness = lerpResult48;
			float lerpResult56 = lerp( 1.0 , tex2DNode30.a , _OcclusionStrength);
			o.Occlusion = lerpResult56;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	
}
/*ASEBEGIN
Version=15301
0;92;1318;786;2826.51;908.7501;2.105799;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;28;-2012.922,-76.91004;Float;True;Property;_HeightRMasksGBAOA;Height(R) Masks(G+B) AO(A);6;0;Create;True;0;0;False;0;None;None;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-772.9654,284.1622;Float;False;Property;_WetEdges;Wet Edges;10;0;Create;True;0;0;False;0;0.15;0;0.15;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-1713.563,-79.08839;Float;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;58;-602.0595,160.4382;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1113.082,773.4055;Float;False;Property;_NormalAScale;Normal A Scale;2;0;Create;True;0;0;False;0;1;0.592;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1075.325,927.7968;Float;False;Property;_NormalBScale;Normal B Scale;5;0;Create;True;0;0;False;0;1;0.813;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-75.92218,-58.14456;Float;False;Property;_WaterOpacity;Water Opacity;11;0;Create;True;0;0;False;0;0;0;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-315.2288,161.3014;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-782.124,-156.6205;Float;True;Property;_BaseColorB;BaseColor B;3;1;[NoScaleOffset];Create;True;0;0;False;0;None;6aa34313375c232459d7de6dfee3a500;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-812.9641,632.8931;Float;True;Property;_NormalA;Normal A;1;1;[NoScaleOffset];Create;True;0;0;False;0;None;5a8b4e10eaa58024c89a5d503d83bed8;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-812.9808,825.3356;Float;True;Property;_NormalB;Normal B;4;1;[NoScaleOffset];Create;True;0;0;False;0;None;2d86f82ddd854624dbefe091f065e909;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-795.21,-367.3024;Float;True;Property;_BaseColorA;Base Color A;0;1;[NoScaleOffset];Create;True;0;0;False;0;None;d2c0802492fd93447b2390f2ee2ba6d4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;57;-192.1861,389.9368;Float;False;Property;_OcclusionStrength;Occlusion Strength;9;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;188.6439,104.1562;Float;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;False;0;0.98;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;64;-189.5996,643.1654;Float;True;Property;_TextureSample1;Texture Sample 1;12;1;[HideInInspector];Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;62;80.7663,-19.71152;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;-348.4275,-292.3393;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;7;-426.7621,763.4731;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;8;-345.7052,-153.6669;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;47;85.06364,-440.6774;Float;False;Property;_WaterColor;Water Color;8;0;Create;True;0;0;False;0;0.3161765,0.2515303,0.1697124,0;0.3161765,0.2515303,0.1697124,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;48;398.1268,-14.33352;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-267.0843,27.75564;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-563.9111,58.06955;Float;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;False;0;1;0.74;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;50;193.9503,595.328;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;45;351.2898,-177.428;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;56;137.6463,302.1918;Float;False;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;857.0855,100.081;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Triplebrick/FloorBlendStandard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;28;0
WireConnection;58;0;30;3
WireConnection;58;1;61;0
WireConnection;60;0;58;0
WireConnection;3;5;31;0
WireConnection;4;5;32;0
WireConnection;62;0;63;0
WireConnection;62;1;60;0
WireConnection;6;0;2;0
WireConnection;6;1;1;0
WireConnection;6;2;30;2
WireConnection;7;0;4;0
WireConnection;7;1;3;0
WireConnection;7;2;30;2
WireConnection;8;0;2;4
WireConnection;8;1;1;4
WireConnection;8;2;30;2
WireConnection;48;0;8;0
WireConnection;48;1;49;0
WireConnection;48;2;60;0
WireConnection;39;0;8;0
WireConnection;39;1;35;0
WireConnection;50;0;7;0
WireConnection;50;1;64;0
WireConnection;50;2;60;0
WireConnection;45;0;6;0
WireConnection;45;1;47;0
WireConnection;45;2;62;0
WireConnection;56;1;30;4
WireConnection;56;2;57;0
WireConnection;0;0;45;0
WireConnection;0;1;50;0
WireConnection;0;4;48;0
WireConnection;0;5;56;0
ASEEND*/
//CHKSM=F422E47956A72B9A53B0C2E35F35C41B4121CF25