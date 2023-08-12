// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Triplebrick/Godrays"
{
	Properties
	{
		_EmissionStrength("Emission Strength", Range( 0 , 500)) = 0
		_Tint("Tint", Color) = (1,1,1,0)
		[NoScaleOffset]_Basecolor("Basecolor", 2D) = "white" {}
		_Offset("Offset", Float) = 10
		_Length("Length", Float) = 40
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float eyeDepth;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _EmissionStrength;
		uniform float4 _Tint;
		uniform sampler2D _Basecolor;
		uniform float _Length;
		uniform float _Offset;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 panner26 = ( _Time.y * float2( 0.00753,0 ) + i.uv_texcoord);
			float4 tex2DNode27 = tex2D( _Basecolor, panner26 );
			float2 panner19 = ( _Time.y * float2( -0.00389,0 ) + i.uv_texcoord);
			float4 tex2DNode1 = tex2D( _Basecolor, panner19 );
			float4 temp_output_29_0 = ( tex2DNode27 + tex2DNode1 );
			float cameraDepthFade34 = (( i.eyeDepth -_ProjectionParams.y - _Offset ) / _Length);
			float4 temp_cast_0 = (0.0).xxxx;
			float4 temp_cast_1 = (500.0).xxxx;
			float4 clampResult37 = clamp( ( ( _EmissionStrength * ( _Tint * temp_output_29_0 ) ) * cameraDepthFade34 ) , temp_cast_0 , temp_cast_1 );
			o.Emission = clampResult37.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNDotV6 = dot( normalize( ase_worldNormal ), ase_worldViewDir );
			float fresnelNode6 = ( -0.05 + 1.41 * pow( 1.0 - fresnelNDotV6, 1.0 ) );
			float4 clampResult17 = clamp( ( ( temp_output_29_0 * ( 1.0 - fresnelNode6 ) ) * cameraDepthFade34 ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			o.Alpha = clampResult17.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.z = customInputData.eyeDepth;
				o.worldPos = worldPos;
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
				surfIN.eyeDepth = IN.customPack1.z;
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	
}
/*ASEBEGIN
Version=15301
0;92;791;748;1332.66;530.7587;1;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;18;-2204.976,124.4638;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-2414.745,-161.4728;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;20;-2324.806,-2.895647;Float;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;-0.00389,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-2392.934,-559.8694;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;25;-2317.282,-416.6778;Float;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;False;0;0.00753,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;23;-2168.88,-258.4483;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;26;-2001.225,-400.1089;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;19;-2023.034,-1.712246;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;22;-2745.426,-367.6456;Float;True;Property;_Basecolor;Basecolor;2;1;[NoScaleOffset];Create;True;0;0;False;0;None;c24a378c21614c241b4fe0b9db7a8c6d;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;27;-1734.234,-495.5405;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1756.043,-97.14384;Float;True;Property;_Basea;Base a;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-917.9333,-431.4497;Float;False;Property;_Tint;Tint;1;0;Create;True;0;0;False;0;1,1,1,0;0.6985294,0.8378296,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-1330.873,-128.6091;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;6;-1597.83,261.8436;Float;True;Tangent;4;0;FLOAT3;0,0,1;False;1;FLOAT;-0.05;False;2;FLOAT;1.41;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-659.9333,-131.4497;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1013.396,102.7208;Float;False;Property;_Offset;Offset;3;0;Create;True;0;0;False;0;10;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-592.6645,-385.2894;Float;False;Property;_EmissionStrength;Emission Strength;0;0;Create;True;0;0;False;0;0;10;0;500;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1028.005,-0.8704381;Float;False;Property;_Length;Length;4;0;Create;True;0;0;False;0;40;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;15;-1256.554,324.2632;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-945.5325,239.7324;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CameraDepthFade;34;-791.5403,24.75967;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;40;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-340.3105,-267.0289;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-357.3146,166.2965;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;500;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-493.3146,82.29649;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-303.2939,-54.59418;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-570.4904,244.4333;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;37;-152.1107,-42.78096;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;17;-179.8177,243.2435;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1387.086,-258.9719;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Triplebrick/Godrays;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;24;0
WireConnection;26;2;25;0
WireConnection;26;1;23;0
WireConnection;19;0;21;0
WireConnection;19;2;20;0
WireConnection;19;1;18;0
WireConnection;27;0;22;0
WireConnection;27;1;26;0
WireConnection;1;0;22;0
WireConnection;1;1;19;0
WireConnection;29;0;27;0
WireConnection;29;1;1;0
WireConnection;4;0;5;0
WireConnection;4;1;29;0
WireConnection;15;0;6;0
WireConnection;7;0;29;0
WireConnection;7;1;15;0
WireConnection;34;0;40;0
WireConnection;34;1;41;0
WireConnection;2;0;3;0
WireConnection;2;1;4;0
WireConnection;36;0;2;0
WireConnection;36;1;34;0
WireConnection;35;0;7;0
WireConnection;35;1;34;0
WireConnection;37;0;36;0
WireConnection;37;1;39;0
WireConnection;37;2;38;0
WireConnection;17;0;35;0
WireConnection;28;0;27;0
WireConnection;28;1;1;0
WireConnection;0;2;37;0
WireConnection;0;9;17;0
ASEEND*/
//CHKSM=3F957EB01E7C93861E9CE2C780A2D35184B2C6AD