// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Lordenfel/Ivy"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.47
		_Normal("Normal", 2D) = "bump" {}
		_Mask("Mask", 2D) = "white" {}
		_SmoothnessMin("Smoothness Min", Float) = 0.49
		_SmoothnessMax("Smoothness Max", Float) = 0.8
		_Specular("Specular", Float) = 0.12
		_EdgeShift("Edge Shift", Float) = -0.4
		_OpacityContrast("Opacity Contrast", Float) = 0.26
		_Transmission("Transmission", Float) = 3.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecularCustom keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		struct SurfaceOutputStandardSpecularCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half3 Specular;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Transmission;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _Specular;
		uniform float _SmoothnessMin;
		uniform float _SmoothnessMax;
		uniform float _Transmission;
		uniform float _EdgeShift;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float _OpacityContrast;
		uniform float _Cutoff = 0.47;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		inline half4 LightingStandardSpecularCustom(SurfaceOutputStandardSpecularCustom s, half3 viewDir, UnityGI gi )
		{
			half3 transmission = max(0 , -dot(s.Normal, gi.light.dir)) * gi.light.color * s.Transmission;
			half4 d = half4(s.Albedo * transmission , 0);

			SurfaceOutputStandardSpecular r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Specular = s.Specular;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandardSpecular (r, viewDir, gi) + d;
		}

		inline void LightingStandardSpecularCustom_GI(SurfaceOutputStandardSpecularCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardSpecularCustom o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode10 = tex2D( _Albedo, uv_Albedo );
			o.Albedo = tex2DNode10.rgb;
			float3 temp_cast_1 = (_Specular).xxx;
			o.Specular = temp_cast_1;
			float lerpResult15 = lerp( _SmoothnessMin , _SmoothnessMax , tex2DNode10.r);
			o.Smoothness = lerpResult15;
			o.Transmission = ( tex2DNode10 * _Transmission ).rgb;
			o.Alpha = 1;
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float4 tex2DNode1 = tex2D( _Mask, uv_Mask );
			float4 temp_cast_3 = (( tex2DNode1.r + tex2DNode1.b )).xxxx;
			clip( ( ( ( CalculateContrast(_EdgeShift,temp_cast_3) + i.vertexColor.a ) * tex2DNode1.a ) * _OpacityContrast ).r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Standard (Specular setup)"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
618;78;1779;1215;1425.294;334.7736;1;True;False
Node;AmplifyShaderEditor.SamplerNode;1;-1871.086,167.9506;Inherit;True;Property;_Mask;Mask;3;0;Create;True;0;0;False;0;False;-1;None;b99774c781a7ee149a75be07767e55d0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1479.086,350.9505;Inherit;False;Property;_EdgeShift;Edge Shift;7;0;Create;True;0;0;False;0;False;-0.4;-0.53;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-1454.086,207.9505;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;6;-1226.308,416.6938;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;3;-1263.086,199.9505;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-973.308,343.6936;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;10;-850.3923,-153.335;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;False;-1;None;291f629bc04efe2499aad0de0173196d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-417.3762,227.6658;Inherit;False;Property;_SmoothnessMin;Smoothness Min;4;0;Create;True;0;0;False;0;False;0.49;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-412.3762,311.6658;Inherit;False;Property;_SmoothnessMax;Smoothness Max;5;0;Create;True;0;0;False;0;False;0.8;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-838.4924,491.4194;Inherit;False;Property;_OpacityContrast;Opacity Contrast;8;0;Create;True;0;0;False;0;False;0.26;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-784.4924,350.4194;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-506.3762,150.6658;Inherit;False;Property;_Transmission;Transmission;9;0;Create;True;0;0;False;0;False;3.5;3.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;15;-193.3762,241.6658;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-267.3762,147.6658;Inherit;False;Property;_Specular;Specular;6;0;Create;True;0;0;False;0;False;0.12;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-311.3762,50.66583;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-602.4924,430.4194;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;11;-840.3762,79.66583;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;False;0;False;-1;None;d181deedb4a5bba43bb15e36d739e25f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;86,64;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Custom/Lordenfel/Ivy;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.47;True;True;0;False;TransparentCutout;;AlphaTest;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;Standard (Specular setup);1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;1
WireConnection;2;1;1;3
WireConnection;3;1;2;0
WireConnection;3;0;4;0
WireConnection;5;0;3;0
WireConnection;5;1;6;4
WireConnection;7;0;5;0
WireConnection;7;1;1;4
WireConnection;15;0;16;0
WireConnection;15;1;17;0
WireConnection;15;2;10;1
WireConnection;13;0;10;0
WireConnection;13;1;12;0
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;0;0;10;0
WireConnection;0;1;11;0
WireConnection;0;3;14;0
WireConnection;0;4;15;0
WireConnection;0;6;13;0
WireConnection;0;10;8;0
ASEEND*/
//CHKSM=7CC0BF4C991F7CD29C0374B4C63AF194617ACE3B