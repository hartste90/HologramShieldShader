Shader "Lexdev/CaseStudies/OverwatchShield"
{
	Properties
	{
		_Color("Color", COLOR) = (1.0,0.5,0.0,0.5)
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

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//final output
				return _Color;

			}
			

			ENDHLSL
		}
	}
}
