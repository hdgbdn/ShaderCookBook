Shader "HudiShader/Silhouette" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_DotProduct("Rim effect", Range(-1, 1)) = 0.25
	}
	SubShader {
		Tags { 
			"Queue" = "Transparent"
			"RenderType"="Transparent"
			"IgnoreProjector" = "True"
			 }
		LOD 200

		CGPROGRAM
		// No need to use standrand surface shader, use Lambert lighting model and disable lighting
		#pragma surface surf Lambert alpha:fade nolighting

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		// Add world normal and view direction
		struct Input {
			float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _DotProduct;

		// Change the output from SurfaceOutputStandard to SurfaceOutput becacuse we changed the
		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			float border = 1 - (abs(dot(IN.worldNormal, IN.viewDir)));
			float alpha = (border * (1 - _DotProduct) + _DotProduct);
			o.Alpha = c.a * alpha;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
