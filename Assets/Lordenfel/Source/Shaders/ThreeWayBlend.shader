// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Lordenfel/ThreeWayBlend"
{
	Properties
	{
		_Layer1Albedo("Layer 1 Albedo", 2D) = "white" {}
		_Layer1Normal("Layer 1 Normal", 2D) = "bump" {}
		_Layer1SmoothnessMin("Layer 1 Smoothness Min", Float) = 0.2
		_Layer3SmoothnessMin("Layer 3 Smoothness Min", Float) = 0.2
		_Layer2SmoothnessMin("Layer 2 Smoothness Min", Float) = 0.2
		_Layer1SmoothnessMax("Layer 1 Smoothness Max", Float) = 0.8
		_Layer3SmoothnessMax("Layer 3 Smoothness Max", Float) = 0.8
		_Layer2SmoothnessMax("Layer 2 Smoothness Max", Float) = 0.8
		_Layer2Albedo("Layer 2 Albedo", 2D) = "white" {}
		_Layer3Albedo("Layer 3 Albedo", 2D) = "white" {}
		_Layer2Normal("Layer 2 Normal", 2D) = "bump" {}
		_Layer3Normal("Layer 3 Normal", 2D) = "bump" {}
		_Specular("Specular", Float) = 0.02
		_Layer3EdgeSmoothness("Layer 3 Edge Smoothness", Float) = 50
		_Layer3BlendPrecision("Layer 3 Blend Precision", Float) = 5
		_Layer2EdgeSmoothness("Layer 2 Edge Smoothness", Float) = 50
		_Layer2BlendPrecision("Layer 2 Blend Precision", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Layer1Normal;
		uniform float4 _Layer1Normal_ST;
		uniform sampler2D _Layer2Normal;
		uniform float4 _Layer2Normal_ST;
		uniform float _Layer2EdgeSmoothness;
		uniform float _Layer2BlendPrecision;
		uniform sampler2D _Layer1Albedo;
		uniform float4 _Layer1Albedo_ST;
		uniform sampler2D _Layer3Normal;
		uniform float4 _Layer3Normal_ST;
		uniform float _Layer3EdgeSmoothness;
		uniform float _Layer3BlendPrecision;
		uniform sampler2D _Layer2Albedo;
		uniform float4 _Layer2Albedo_ST;
		uniform sampler2D _Layer3Albedo;
		uniform float4 _Layer3Albedo_ST;
		uniform float _Specular;
		uniform float _Layer1SmoothnessMin;
		uniform float _Layer1SmoothnessMax;
		uniform float _Layer2SmoothnessMin;
		uniform float _Layer2SmoothnessMax;
		uniform float _Layer3SmoothnessMin;
		uniform float _Layer3SmoothnessMax;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Layer1Normal = i.uv_texcoord * _Layer1Normal_ST.xy + _Layer1Normal_ST.zw;
			float2 uv_Layer2Normal = i.uv_texcoord * _Layer2Normal_ST.xy + _Layer2Normal_ST.zw;
			float temp_output_2_0_g4 = _Layer2EdgeSmoothness;
			float temp_output_5_0_g4 = ( temp_output_2_0_g4 / _Layer2BlendPrecision );
			float temp_output_4_0_g4 = ( 1.0 - i.vertexColor.r );
			float lerpResult7_g4 = lerp( ( 1.0 - temp_output_5_0_g4 ) , temp_output_5_0_g4 , temp_output_4_0_g4);
			float2 uv_Layer1Albedo = i.uv_texcoord * _Layer1Albedo_ST.xy + _Layer1Albedo_ST.zw;
			float4 tex2DNode1 = tex2D( _Layer1Albedo, uv_Layer1Albedo );
			float lerpResult11_g4 = lerp( ( temp_output_2_0_g4 + lerpResult7_g4 ) , ( ( 1.0 - temp_output_2_0_g4 ) + lerpResult7_g4 ) , tex2DNode1.a);
			float clampResult12_g4 = clamp( lerpResult11_g4 , 0.0 , 1.0 );
			float lerpResult13_g4 = lerp( 0.0 , clampResult12_g4 , temp_output_4_0_g4);
			float temp_output_28_0 = lerpResult13_g4;
			float3 lerpResult17 = lerp( UnpackNormal( tex2D( _Layer1Normal, uv_Layer1Normal ) ) , UnpackNormal( tex2D( _Layer2Normal, uv_Layer2Normal ) ) , temp_output_28_0);
			float2 uv_Layer3Normal = i.uv_texcoord * _Layer3Normal_ST.xy + _Layer3Normal_ST.zw;
			float temp_output_2_0_g5 = _Layer3EdgeSmoothness;
			float temp_output_5_0_g5 = ( temp_output_2_0_g5 / _Layer3BlendPrecision );
			float temp_output_4_0_g5 = ( 1.0 - i.vertexColor.g );
			float lerpResult7_g5 = lerp( ( 1.0 - temp_output_5_0_g5 ) , temp_output_5_0_g5 , temp_output_4_0_g5);
			float2 uv_Layer2Albedo = i.uv_texcoord * _Layer2Albedo_ST.xy + _Layer2Albedo_ST.zw;
			float4 tex2DNode7 = tex2D( _Layer2Albedo, uv_Layer2Albedo );
			float lerpResult18 = lerp( tex2DNode1.a , tex2DNode7.a , temp_output_28_0);
			float lerpResult11_g5 = lerp( ( temp_output_2_0_g5 + lerpResult7_g5 ) , ( ( 1.0 - temp_output_2_0_g5 ) + lerpResult7_g5 ) , lerpResult18);
			float clampResult12_g5 = clamp( lerpResult11_g5 , 0.0 , 1.0 );
			float lerpResult13_g5 = lerp( 0.0 , clampResult12_g5 , temp_output_4_0_g5);
			float temp_output_33_0 = lerpResult13_g5;
			float3 lerpResult26 = lerp( lerpResult17 , UnpackNormal( tex2D( _Layer3Normal, uv_Layer3Normal ) ) , temp_output_33_0);
			o.Normal = lerpResult26;
			float4 lerpResult15 = lerp( tex2DNode1 , tex2DNode7 , temp_output_28_0);
			float2 uv_Layer3Albedo = i.uv_texcoord * _Layer3Albedo_ST.xy + _Layer3Albedo_ST.zw;
			float4 tex2DNode20 = tex2D( _Layer3Albedo, uv_Layer3Albedo );
			float4 lerpResult24 = lerp( lerpResult15 , tex2DNode20 , temp_output_33_0);
			o.Albedo = lerpResult24.rgb;
			float3 temp_cast_1 = (_Specular).xxx;
			o.Specular = temp_cast_1;
			float lerpResult4 = lerp( _Layer1SmoothnessMin , _Layer1SmoothnessMax , tex2DNode1.r);
			float lerpResult9 = lerp( _Layer2SmoothnessMin , _Layer2SmoothnessMax , tex2DNode7.r);
			float lerpResult16 = lerp( lerpResult4 , lerpResult9 , temp_output_28_0);
			float lerpResult23 = lerp( _Layer3SmoothnessMin , _Layer3SmoothnessMax , tex2DNode20.r);
			float lerpResult25 = lerp( lerpResult16 , lerpResult23 , temp_output_33_0);
			o.Smoothness = lerpResult25;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Standard (Specular setup)"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
-1913;353;1824;1058;4571.206;747.649;2.235434;True;False
Node;AmplifyShaderEditor.VertexColorNode;12;-3371.165,200.9968;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-3194.101,112.261;Inherit;False;Property;_Layer2BlendPrecision;Layer 2 Blend Precision;16;0;Create;True;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;29;-3152.101,221.261;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-3728.55,-195.3502;Inherit;True;Property;_Layer1Albedo;Layer 1 Albedo;0;0;Create;True;0;0;False;0;False;-1;None;59d8ee64e2b2c734c8f99343379c0317;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-3211.101,32.26099;Inherit;False;Property;_Layer2EdgeSmoothness;Layer 2 Edge Smoothness;15;0;Create;True;0;0;False;0;False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-3720.558,559.9141;Inherit;True;Property;_Layer2Albedo;Layer 2 Albedo;8;0;Create;True;0;0;False;0;False;-1;None;ad6fbdf7765069843882fa17825d3237;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;28;-2894.101,66.26099;Inherit;False;HeightLerp_Lordenfel;-1;;4;f647aa9a482e9f84281f939249978d59;0;4;1;FLOAT;0.5;False;2;FLOAT;50;False;3;FLOAT;5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-3385.709,570.1342;Inherit;False;Property;_Layer2SmoothnessMax;Layer 2 Smoothness Max;7;0;Create;True;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-3384.709,480.1342;Inherit;False;Property;_Layer2SmoothnessMin;Layer 2 Smoothness Min;4;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-3313.805,-206.2624;Inherit;False;Property;_Layer1SmoothnessMax;Layer 1 Smoothness Max;5;0;Create;True;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-3308.805,-284.2622;Inherit;False;Property;_Layer1SmoothnessMin;Layer 1 Smoothness Min;2;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1694.057,-25.70866;Inherit;False;Property;_Layer3SmoothnessMin;Layer 3 Smoothness Min;3;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;32;-2168.777,666.765;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;-2452.312,514.1393;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1696.057,64.2912;Inherit;False;Property;_Layer3SmoothnessMax;Layer 3 Smoothness Max;6;0;Create;True;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;9;-3042.962,503.4957;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-2174.052,-300.3235;Inherit;True;Property;_Layer3Albedo;Layer 3 Albedo;9;0;Create;True;0;0;False;0;False;-1;None;fe4b83417e99751488852bcf466972d5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;4;-3044.305,-201.2623;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-3720.558,771.9143;Inherit;True;Property;_Layer2Normal;Layer 2 Normal;10;0;Create;True;0;0;False;0;False;-1;None;c4ee664a4a0e37b4ca781c3187aea05e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-2164.475,485.3649;Inherit;False;Property;_Layer3EdgeSmoothness;Layer 3 Edge Smoothness;13;0;Create;True;0;0;False;0;False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2146.475,564.365;Inherit;False;Property;_Layer3BlendPrecision;Layer 3 Blend Precision;14;0;Create;True;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-3727.55,12.6498;Inherit;True;Property;_Layer1Normal;Layer 1 Normal;1;0;Create;True;0;0;False;0;False;-1;None;5e6ec4a68e49dcc4aa7ea6ab378e4a88;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;23;-1436.055,7.291305;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;16;-2455.297,85.81567;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;15;-2447.861,-140.6095;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;33;-1864.575,495.9651;Inherit;False;HeightLerp_Lordenfel;-1;;5;f647aa9a482e9f84281f939249978d59;0;4;1;FLOAT;0.5;False;2;FLOAT;50;False;3;FLOAT;5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;-2456.597,290.732;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;19;-2174.052,-89.62315;Inherit;True;Property;_Layer3Normal;Layer 3 Normal;11;0;Create;True;0;0;False;0;False;-1;None;eddb60cbfc043ad488f68dfbdda29886;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;26;-1163.609,379.7777;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;24;-1159.682,-167.4163;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-989.1133,22.35301;Inherit;False;Property;_Specular;Specular;12;0;Create;True;0;0;False;0;False;0.02;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;25;-1162.3,104.8717;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-771.344,-38.47826;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Custom/Lordenfel/ThreeWayBlend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;Standard (Specular setup);-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;0;12;1
WireConnection;28;1;1;4
WireConnection;28;2;31;0
WireConnection;28;3;30;0
WireConnection;28;4;29;0
WireConnection;32;0;12;2
WireConnection;18;0;1;4
WireConnection;18;1;7;4
WireConnection;18;2;28;0
WireConnection;9;0;38;0
WireConnection;9;1;39;0
WireConnection;9;2;7;1
WireConnection;4;0;5;0
WireConnection;4;1;6;0
WireConnection;4;2;1;1
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;23;2;20;1
WireConnection;16;0;4;0
WireConnection;16;1;9;0
WireConnection;16;2;28;0
WireConnection;15;0;1;0
WireConnection;15;1;7;0
WireConnection;15;2;28;0
WireConnection;33;1;18;0
WireConnection;33;2;35;0
WireConnection;33;3;36;0
WireConnection;33;4;32;0
WireConnection;17;0;2;0
WireConnection;17;1;8;0
WireConnection;17;2;28;0
WireConnection;26;0;17;0
WireConnection;26;1;19;0
WireConnection;26;2;33;0
WireConnection;24;0;15;0
WireConnection;24;1;20;0
WireConnection;24;2;33;0
WireConnection;25;0;16;0
WireConnection;25;1;23;0
WireConnection;25;2;33;0
WireConnection;0;0;24;0
WireConnection;0;1;26;0
WireConnection;0;3;37;0
WireConnection;0;4;25;0
ASEEND*/
//CHKSM=A0788610E79AAFDEC9C3A708E0CE756A4D099D19