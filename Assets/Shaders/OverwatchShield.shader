Shader "Lexdev/CaseStudies/OverwatchShield"
{
	Properties
	{
		_Color("Color", COLOR) = (1.0,0.5,0.0,0.5)
		_PulseTex("Hex Pulse Texture", 2D) = "white" {}
		_PulseIntensity ("Hex Pulse Intensity", float) = 3.0
		_PulseTimeScale("Hex Pulse Time Scale", float) = 2.0
		_PulsePosScale("Hex Pulse Position Scale", float) = 50.0
		_PulseTexOffsetScale("Hex Pulse Texture Offset Scale", float) = 1.5
		_HexEdgeTex("Hex Edge Texture", 2D) = "white" {}
		_HexEdgeIntensity("Hex Edge Intensity", float) = 2.0
		_HexEdgeColor("Hex Edge Color", COLOR) = (0,0,0,0)
		_HexEdgeTimeScale("Hex Edge Time Scale", float) = 2.0
		_HexEdgeWidthModifier("Hex Edge Width Modifier", Range(0,1)) = 0.8
		_HexEdgePosScale("Hex Edge Position Scale", float) = 80.0
		_EdgeTex("Edge Texture", 2D) = "white" {}
		_EdgeIntensity("Edge Intensity", float) = 10.0
		_EdgeExponent("Edge Falloff Exponent", float) = 6.0



	}
	SubShader
	{

		Pass
		{
			Cull Off
			Tags {"RenderType" = "Transparent" "Queue" = "Transparent"}
			Blend SrcAlpha One

			HLSLPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			float4 _Color;
			sampler2D _PulseTex;
			float4 _PulseTex_ST;
			float _PulseIntensity;
			float _PulseTimeScale;
			float _PulsePosScale;
			float _PulseTexOffsetScale;

			sampler2D _HexEdgeTex;
			float4 _HexEdgeTex_ST;
			float _HexEdgeIntensity;
			float4 _HexEdgeColor;
			float _HexEdgeTimeScale;
			float _HexEdgeWidthModifier;
			float _HexEdgePosScale;

			sampler2D _EdgeTex;
			float4 _EdgeTex_ST;
			float _EdgeIntensity;
			float _EdgeExponent;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 vertexObjPos : TEXCOORD1;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _PulseTex);
				o.vertexObjPos = v.vertex;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 pulseTex = tex2D(_PulseTex, i.uv);
				fixed4 hexEdgeTex = tex2D(_HexEdgeTex, i.uv);
				fixed4 edgeTex = tex2D(_EdgeTex, i.uv);
				float horizontalDist = abs(i.vertexObjPos.x);
				float verticalDist = abs(i.vertexObjPos.z);
    			fixed4 pulseTerm = pulseTex * _Color * _PulseIntensity * abs(sin(_Time.y * _PulseTimeScale - horizontalDist * _PulsePosScale + pulseTex.r * _PulseTexOffsetScale));

				fixed4 hexEdgeTerm = hexEdgeTex * _HexEdgeColor * _HexEdgeIntensity *
    max(sin((horizontalDist + verticalDist) * _HexEdgePosScale - _Time.y * _HexEdgeTimeScale) - _HexEdgeWidthModifier, 0.0f) *
    (1 / (1 - _HexEdgeWidthModifier));

    			fixed4 edgeTerm = pow(edgeTex.a, _EdgeExponent) * _Color * _EdgeIntensity;

				//final output
				return fixed4(_Color.rgb + pulseTerm.rgb + hexEdgeTerm.rgb + edgeTerm.rgb, _Color.a);



			}
			

			ENDHLSL
		}
	}
}
