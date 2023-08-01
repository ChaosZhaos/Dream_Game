// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Triplebrick/Flame"
{
	Properties
	{
		_flame_basecolor("flame_basecolor", 2D) = "white" {}
		_Utils_map("Utils_map", 2D) = "white" {}
		_TileSpeed1("TileSpeed", Vector) = (0,0,0,0)
		_Emission("Emission", Range( 1 , 10)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Utils_map;
		uniform float2 _TileSpeed1;
		uniform sampler2D _flame_basecolor;
		uniform float4 _flame_basecolor_ST;
		uniform float _Emission;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_TexCoord6 = v.texcoord.xy * float2( 0.4,0.4 );
			float2 panner7 = ( _Time.x * _TileSpeed1 + uv_TexCoord6);
			float4 tex2DNode2 = tex2Dlod( _Utils_map, float4( panner7, 0, 0.0) );
			float3 appendResult8 = (float3(( tex2DNode2.r * 0.02 ) , ( tex2DNode2.g * 0.1 ) , ( tex2DNode2.b * 0.02 )));
			v.vertex.xyz += appendResult8;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_flame_basecolor = i.uv_texcoord * _flame_basecolor_ST.xy + _flame_basecolor_ST.zw;
			o.Emission = ( tex2D( _flame_basecolor, uv_flame_basecolor ) * _Emission ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	
}
/*ASEBEGIN
Version=17400
0;73;639;652;1051.507;620.6649;2.108066;True;False
Node;AmplifyShaderEditor.TimeNode;4;-1680.719,275.8847;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;3;-1636.376,123.2896;Float;False;Property;_TileSpeed1;TileSpeed;2;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1672.368,-46.73323;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.4,0.4;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;7;-1281.578,138.5764;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-766.2263,216.3946;Inherit;True;Property;_Utils_map;Utils_map;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-437.7076,133.5663;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-442.688,247.5663;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-457.7076,346.5467;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-786.4474,-232.6812;Inherit;True;Property;_flame_basecolor;flame_basecolor;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-640.4886,28.7233;Inherit;False;Property;_Emission;Emission;3;0;Create;True;0;0;False;0;1;0;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-261.7003,285.5032;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-321.522,-107.3502;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Triplebrick/Flame;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;6;0
WireConnection;7;2;3;0
WireConnection;7;1;4;1
WireConnection;2;1;7;0
WireConnection;9;0;2;1
WireConnection;10;0;2;2
WireConnection;11;0;2;3
WireConnection;8;0;9;0
WireConnection;8;1;10;0
WireConnection;8;2;11;0
WireConnection;17;0;1;0
WireConnection;17;1;18;0
WireConnection;0;2;17;0
WireConnection;0;11;8;0
ASEEND*/
//CHKSM=83304238FB5CD897BAD7C0E8DFB342F8EA4CD6AA