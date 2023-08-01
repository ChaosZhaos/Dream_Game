// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Lordenfel/FoliageWind"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_ColorOverlay("Color Overlay", Color) = (0.7075472,0.7075472,0.7075472,1)
		_Desaturation("Desaturation", Float) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.25
		_Normal("Normal", 2D) = "bump" {}
		_Specular("Specular", Float) = 0.1
		_SmoothnessMin("Smoothness Min", Float) = 0.2
		_SmoothnessMax("Smoothness Max", Float) = 0.8
		_Transmission("Transmission", Float) = 3.6
		_WindNormal("Wind Normal", 2D) = "white" {}
		_WindOverallIntensity("Wind Overall Intensity", Float) = 0.025
		_WindScalePrimary("Wind Scale Primary", Float) = 55
		_WindScaleSecondary("Wind Scale Secondary", Float) = 20
		_WindSecondaryIntensity("Wind Secondary Intensity", Float) = 0.5
		_TimeScale("Time Scale", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecularCustom keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
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

		uniform sampler2D _WindNormal;
		uniform float _TimeScale;
		uniform float _WindScalePrimary;
		uniform float _WindScaleSecondary;
		uniform float _WindSecondaryIntensity;
		uniform float _WindOverallIntensity;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _ColorOverlay;
		uniform float _Desaturation;
		uniform float _Specular;
		uniform float _SmoothnessMin;
		uniform float _SmoothnessMax;
		uniform float _Transmission;
		uniform float _Cutoff = 0.25;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime10 = _Time.y * _TimeScale;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 temp_output_3_0 = (ase_worldPos).xz;
			float2 panner1 = ( mulTime10 * float2( 0.05,0.05 ) + ( temp_output_3_0 / _WindScalePrimary ));
			float3 tex2DNode13 = UnpackNormal( tex2Dlod( _WindNormal, float4( panner1, 0, 0.0) ) );
			float4 appendResult15 = (float4(tex2DNode13.r , tex2DNode13.g , 0.0 , 0.0));
			float2 panner11 = ( mulTime10 * float2( 0.05,0.05 ) + ( temp_output_3_0 / _WindScaleSecondary ));
			float3 tex2DNode14 = UnpackNormal( tex2Dlod( _WindNormal, float4( panner11, 0, 0.0) ) );
			float4 appendResult16 = (float4(tex2DNode14.r , tex2DNode14.g , 0.0 , 0.0));
			v.vertex.xyz += ( v.color.r * ( ( appendResult15 + ( appendResult16 * _WindSecondaryIntensity ) ) * _WindOverallIntensity ) ).xyz;
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
			float4 tex2DNode26 = tex2D( _Albedo, uv_Albedo );
			float4 blendOpSrc27 = tex2DNode26;
			float4 blendOpDest27 = _ColorOverlay;
			float3 desaturateInitialColor29 = ( saturate( (( blendOpDest27 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest27 ) * ( 1.0 - blendOpSrc27 ) ) : ( 2.0 * blendOpDest27 * blendOpSrc27 ) ) )).rgb;
			float desaturateDot29 = dot( desaturateInitialColor29, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar29 = lerp( desaturateInitialColor29, desaturateDot29.xxx, _Desaturation );
			o.Albedo = desaturateVar29;
			float3 temp_cast_1 = (_Specular).xxx;
			o.Specular = temp_cast_1;
			float lerpResult32 = lerp( _SmoothnessMin , _SmoothnessMax , tex2DNode26.r);
			o.Smoothness = lerpResult32;
			o.Transmission = ( desaturateVar29 * _Transmission );
			o.Alpha = 1;
			clip( tex2DNode26.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Standard (Specular setup)"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
531;149;1779;1215;3331.939;449.3379;1.3;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-2535.652,172.8645;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;9;-1991.652,236.8645;Inherit;False;Property;_TimeScale;Time Scale;14;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2279.652,477.8646;Inherit;False;Property;_WindScaleSecondary;Wind Scale Secondary;12;0;Create;True;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;3;-2343.652,172.8645;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;6;-1927.652,460.8646;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2279.652,-19.13544;Inherit;False;Property;_WindScalePrimary;Wind Scale Primary;11;0;Create;True;0;0;False;0;False;55;55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-1831.652,252.8645;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;4;-1911.651,-35.13544;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1559.652,140.8645;Inherit;True;Property;_WindNormal;Wind Normal;9;0;Create;True;0;0;False;0;False;0bb17834cc720194f89841cadc732585;0bb17834cc720194f89841cadc732585;True;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;11;-1607.652,460.8646;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0.05;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;14;-1223.652,428.8646;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;1;-1607.652,-35.13544;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0.05;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-983.6519,668.8646;Inherit;False;Property;_WindSecondaryIntensity;Wind Secondary Intensity;13;0;Create;True;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-1223.652,-67.13544;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;16;-871.6518,460.8646;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-871.6518,-40.96073;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-642.4935,455.8276;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;28;-601.2238,-467.2599;Inherit;False;Property;_ColorOverlay;Color Overlay;1;0;Create;True;0;0;False;0;False;0.7075472,0.7075472,0.7075472,1;0.593,0.593,0.593,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-691.1865,-665.7307;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;False;-1;None;145e501f8d46f0d47a959cfb77f03f10;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;27;-174.1867,-665.7307;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-106.9867,-539.3307;Inherit;False;Property;_Desaturation;Desaturation;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-484.8837,131.3649;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-415.6374,266.6115;Inherit;False;Property;_WindOverallIntensity;Wind Overall Intensity;10;0;Create;True;0;0;False;0;False;0.025;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;29;123.8133,-660.7307;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;35;180.6829,-97.20806;Inherit;False;Property;_Transmission;Transmission;8;0;Create;True;0;0;False;0;False;3.6;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-137.5703,133.5289;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-618.3838,-124.4315;Inherit;False;Property;_SmoothnessMax;Smoothness Max;7;0;Create;True;0;0;False;0;False;0.8;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-614.3838,-207.4315;Inherit;False;Property;_SmoothnessMin;Smoothness Min;6;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;22;-65.07824,-88.27535;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;32;-345.3837,-186.4315;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;155.644,111.8895;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;385.7829,-129.9081;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;31;442.0779,-217.3011;Inherit;False;Property;_Specular;Specular;5;0;Create;True;0;0;False;0;False;0.1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;128.9473,-437.8199;Inherit;True;Property;_Normal;Normal;4;0;Create;True;0;0;False;0;False;-1;None;a720937d2ba0ace42a0881ddef30c8e6;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;636.5704,-281.199;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;Custom/Lordenfel/FoliageWind;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.25;True;True;0;True;Opaque;;AlphaTest;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;Standard (Specular setup);3;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;0
WireConnection;6;0;3;0
WireConnection;6;1;7;0
WireConnection;10;0;9;0
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;11;0;6;0
WireConnection;11;1;10;0
WireConnection;14;0;12;0
WireConnection;14;1;11;0
WireConnection;1;0;4;0
WireConnection;1;1;10;0
WireConnection;13;0;12;0
WireConnection;13;1;1;0
WireConnection;16;0;14;1
WireConnection;16;1;14;2
WireConnection;15;0;13;1
WireConnection;15;1;13;2
WireConnection;17;0;16;0
WireConnection;17;1;18;0
WireConnection;27;0;26;0
WireConnection;27;1;28;0
WireConnection;20;0;15;0
WireConnection;20;1;17;0
WireConnection;29;0;27;0
WireConnection;29;1;30;0
WireConnection;21;0;20;0
WireConnection;21;1;19;0
WireConnection;32;0;33;0
WireConnection;32;1;34;0
WireConnection;32;2;26;1
WireConnection;23;0;22;1
WireConnection;23;1;21;0
WireConnection;36;0;29;0
WireConnection;36;1;35;0
WireConnection;0;0;29;0
WireConnection;0;1;37;0
WireConnection;0;3;31;0
WireConnection;0;4;32;0
WireConnection;0;6;36;0
WireConnection;0;10;26;4
WireConnection;0;11;23;0
ASEEND*/
//CHKSM=9C7FC4E58645A0AD1813D22B31070ADB783D7E37