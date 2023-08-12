// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Triplebrick/TwoLayersParallaxOccl"
{
	Properties
	{
		_BaseColorA("Base Color A", 2D) = "white" {}
		_NormalA("Normal A", 2D) = "white" {}
		_NormalAScale("Normal A Scale", Range( 0 , 1)) = 1
		_BaseColorB("BaseColor B", 2D) = "white" {}
		_NormalB("Normal B", 2D) = "white" {}
		_NormalBScale("Normal B Scale", Range( 0 , 1)) = 1
		_HeightMaskAlpha("Height + Mask (Alpha)", 2D) = "white" {}
		_HeightScale("Height Scale", Range( 0 , 1)) = 0.4247461
		_CurvatureU("Curvature U", Range( 0 , 100)) = 0
		_CurvatureV("Curvature V", Range( 0 , 30)) = 0
		_Smoothness("Smoothness", Range( 0 , 2)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[Header(Parallax Occlusion Mapping)]
		_CurvFix("Curvature Bias", Range( 0 , 1)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
			float3 worldNormal;
			float3 worldPos;
		};

		uniform float _NormalAScale;
		uniform sampler2D _NormalA;
		uniform sampler2D _HeightMaskAlpha;
		uniform float _HeightScale;
		uniform float _CurvFix;
		uniform float _CurvatureU;
		uniform float _CurvatureV;
		uniform float4 _HeightMaskAlpha_ST;
		uniform float _NormalBScale;
		uniform sampler2D _NormalB;
		uniform sampler2D _BaseColorA;
		uniform sampler2D _BaseColorB;
		uniform float _Smoothness;


		inline float2 POM( sampler2D heightMap, float2 uvs, float2 dx, float2 dy, float3 normalWorld, float3 viewWorld, float3 viewDirTan, int minSamples, int maxSamples, float parallax, float refPlane, float2 tilling, float2 curv, int index )
		{
			float3 result = 0;
			int stepIndex = 0;
			int numSteps = ( int )lerp( (float)maxSamples, (float)minSamples, (float)dot( normalWorld, viewWorld ) );
			float layerHeight = 1.0 / numSteps;
			float2 plane = parallax * ( viewDirTan.xy / viewDirTan.z );
			uvs += refPlane * plane;
			float2 deltaTex = -plane * layerHeight;
			float2 prevTexOffset = 0;
			float prevRayZ = 1.0f;
			float prevHeight = 0.0f;
			float2 currTexOffset = deltaTex;
			float currRayZ = 1.0f - layerHeight;
			float currHeight = 0.0f;
			float intersection = 0;
			float2 finalTexOffset = 0;
			while ( stepIndex < numSteps + 1 )
			{
				result.z = dot( curv, currTexOffset * currTexOffset );
				currHeight = tex2Dgrad( heightMap, uvs + currTexOffset, dx, dy ).r * ( 1 - result.z );
				if ( currHeight > currRayZ )
				{
					stepIndex = numSteps + 1;
				}
				else
				{
					stepIndex++;
					prevTexOffset = currTexOffset;
					prevRayZ = currRayZ;
					prevHeight = currHeight;
					currTexOffset += deltaTex;
					currRayZ -= layerHeight * ( 1 - result.z ) * (1+_CurvFix);
				}
			}
			int sectionSteps = 10;
			int sectionIndex = 0;
			float newZ = 0;
			float newHeight = 0;
			while ( sectionIndex < sectionSteps )
			{
				intersection = ( prevHeight - prevRayZ ) / ( prevHeight - currHeight + currRayZ - prevRayZ );
				finalTexOffset = prevTexOffset + intersection * deltaTex;
				newZ = prevRayZ - intersection * layerHeight;
				newHeight = tex2Dgrad( heightMap, uvs + finalTexOffset, dx, dy ).r;
				if ( newHeight > newZ )
				{
					currTexOffset = finalTexOffset;
					currHeight = newHeight;
					currRayZ = newZ;
					deltaTex = intersection * deltaTex;
					layerHeight = intersection * layerHeight;
				}
				else
				{
					prevTexOffset = finalTexOffset;
					prevHeight = newHeight;
					prevRayZ = newZ;
					deltaTex = ( 1 - intersection ) * deltaTex;
					layerHeight = ( 1 - intersection ) * layerHeight;
				}
				sectionIndex++;
			}
			#ifdef UNITY_PASS_SHADOWCASTER
			if ( unity_LightShadowBias.z == 0.0 )
			{
			#endif
				if ( result.z > 1 )
					clip( -1 );
			#ifdef UNITY_PASS_SHADOWCASTER
			}
			#endif
			return uvs + finalTexOffset;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float2 appendResult15 = (float2(_CurvatureU , _CurvatureV));
			float2 OffsetPOM19 = POM( _HeightMaskAlpha, i.uv_texcoord, ddx(i.uv_texcoord), ddx(i.uv_texcoord), ase_worldNormal, worldViewDir, i.viewDir, 128, 128, _HeightScale, 0, _HeightMaskAlpha_ST.xy, appendResult15, 0.0 );
			float2 myVarName022 = OffsetPOM19;
			float2 temp_output_20_0 = ddx( i.uv_texcoord );
			float2 temp_output_21_0 = ddy( i.uv_texcoord );
			float2 uv_HeightMaskAlpha = i.uv_texcoord * _HeightMaskAlpha_ST.xy + _HeightMaskAlpha_ST.zw;
			float4 tex2DNode30 = tex2D( _HeightMaskAlpha, uv_HeightMaskAlpha );
			float3 lerpResult7 = lerp( UnpackScaleNormal( tex2D( _NormalA, myVarName022, temp_output_20_0, temp_output_21_0 ) ,_NormalAScale ) , UnpackScaleNormal( tex2D( _NormalB, myVarName022, temp_output_20_0, temp_output_21_0 ) ,_NormalBScale ) , tex2DNode30.a);
			o.Normal = lerpResult7;
			float4 tex2DNode1 = tex2D( _BaseColorA, myVarName022, temp_output_20_0, temp_output_21_0 );
			float4 tex2DNode2 = tex2D( _BaseColorB, myVarName022, temp_output_20_0, temp_output_21_0 );
			float4 lerpResult6 = lerp( tex2DNode1 , tex2DNode2 , tex2DNode30.a);
			o.Albedo = lerpResult6.rgb;
			float lerpResult8 = lerp( tex2DNode1.a , tex2DNode2.a , tex2DNode30.a);
			float temp_output_39_0 = ( lerpResult8 * _Smoothness );
			float clampResult38 = clamp( temp_output_39_0 , 0.0 , 1.0 );
			o.Smoothness = clampResult38;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"

}
/*ASEBEGIN
Version=15301
8;100;1205;789;4140.018;1361.01;3.071455;True;False
Node;AmplifyShaderEditor.RangedFloatNode;13;-2016.854,375.0525;Float;False;Property;_CurvatureV;Curvature V;9;0;Create;True;0;0;False;0;0;0;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2016.854,295.0525;Float;False;Property;_CurvatureU;Curvature U;8;0;Create;True;0;0;False;0;0;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;14;-1808.854,103.0525;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;28;-2700.285,-150.1711;Float;True;Property;_HeightMaskAlpha;Height + Mask (Alpha);6;0;Create;True;0;0;False;0;None;6a700239d392b0e47a76a2e33d01666c;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-1680.854,279.0525;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1896.854,-170.4475;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-1960.854,-10.44748;Float;False;Property;_HeightScale;Height Scale;7;0;Create;True;0;0;False;0;0.4247461;0.02;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxOcclusionMappingNode;19;-1536.154,-225.2475;Float;False;0;128;128;10;0.02;0;False;1,1;True;10,0;False;7;0;FLOAT2;0,0;False;1;SAMPLER2D;sampler119;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT2;0,0;False;6;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DdyOpNode;21;-1174.333,306.3278;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-1233.807,-93.35455;Float;False;myVarName0;1;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DdxOpNode;20;-1174.333,98.04993;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-793.0571,-369.4553;Float;True;Property;_BaseColorA;Base Color A;0;0;Create;True;0;0;False;0;None;d2c0802492fd93447b2390f2ee2ba6d4;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;30;-2480.028,549.0671;Float;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-782.124,-156.6205;Float;True;Property;_BaseColorB;BaseColor B;3;0;Create;True;0;0;False;0;None;6aa34313375c232459d7de6dfee3a500;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-563.9111,58.06955;Float;False;Property;_Smoothness;Smoothness;10;0;Create;True;0;0;False;0;1;0.74;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1188.556,432.2158;Float;False;Property;_NormalAScale;Normal A Scale;2;0;Create;True;0;0;False;0;1;0.592;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;8;-374.5288,-117.6219;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1176.556,610.2158;Float;False;Property;_NormalBScale;Normal B Scale;5;0;Create;True;0;0;False;0;1;0.813;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-789.7278,505.6085;Float;True;Property;_NormalB;Normal B;4;0;Create;True;0;0;False;0;None;2d86f82ddd854624dbefe091f065e909;True;0;True;white;Auto;True;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-225.6329,-5.028137;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-789.7111,313.1663;Float;True;Property;_NormalA;Normal A;1;0;Create;True;0;0;False;0;None;5a8b4e10eaa58024c89a5d503d83bed8;True;0;True;white;Auto;True;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-535.6162,157.3806;Float;False;Property;_SmoothnessContrast;Smoothness Contrast;11;0;Create;True;0;0;False;0;1;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;-376.5826,-248.2689;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;7;-403.5092,443.7461;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;33;-173.7161,165.1931;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;38;42.5752,111.0944;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;210.5282,-4.419421;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Triplebrick/TwoLayersParallaxOccl;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;12;0
WireConnection;15;1;13;0
WireConnection;19;0;18;0
WireConnection;19;1;28;0
WireConnection;19;2;17;0
WireConnection;19;3;14;0
WireConnection;19;5;15;0
WireConnection;21;0;18;0
WireConnection;22;0;19;0
WireConnection;20;0;18;0
WireConnection;1;1;22;0
WireConnection;1;3;20;0
WireConnection;1;4;21;0
WireConnection;30;0;28;0
WireConnection;2;1;22;0
WireConnection;2;3;20;0
WireConnection;2;4;21;0
WireConnection;8;0;1;4
WireConnection;8;1;2;4
WireConnection;8;2;30;4
WireConnection;4;1;22;0
WireConnection;4;3;20;0
WireConnection;4;4;21;0
WireConnection;4;5;32;0
WireConnection;39;0;8;0
WireConnection;39;1;35;0
WireConnection;3;1;22;0
WireConnection;3;3;20;0
WireConnection;3;4;21;0
WireConnection;3;5;31;0
WireConnection;6;0;1;0
WireConnection;6;1;2;0
WireConnection;6;2;30;4
WireConnection;7;0;3;0
WireConnection;7;1;4;0
WireConnection;7;2;30;4
WireConnection;33;0;39;0
WireConnection;33;1;36;0
WireConnection;38;0;39;0
WireConnection;0;0;6;0
WireConnection;0;1;7;0
WireConnection;0;4;38;0
ASEEND*/
//CHKSM=F9A8152A494FEE86B2EE4C90DAD30742ADAC89FC