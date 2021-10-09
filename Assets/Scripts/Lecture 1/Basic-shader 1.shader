Shader "Unlit/Basic-shader"{
    Properties{
        // input data
        //_MainTex ("Texture", 2D) = "white" {}
        _value("Value", Float) = 1.0
    }
    SubShader{
        Tags{
            "RenderType"="Opaque"
        }
        Pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"

            // sampler2D _MainTex;
            // float4 _MainTex_ST;

            float _value;

            //automatically filled out by Unity
            struct MeshData{ // per-vertex mesh data
                float4 vertex : POSITION; // local space vertex position
                float3 normals : NORMAL; // local space normal direction
                //float3 tangent : TANGENT; // tangent direction (xyz) tangent sign (w)
                //float4 color : COLOR; // vertex colors 
                float4 uv0 : TEXCOORD0; // uv0 diffuse/normal map textures
                //float4 uv1 : TEXCOORD1; // uv1 coordinates lightmap coordinate
            };

            struct Interpolators{
                float4 vertex : SV_POSITION; // clip space position
                //float2 uv : TEXCOORD0;
            };


            Interpolators vert (MeshData v) {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); // local space to clip space
                return o;
            }

/*---------------------------Data types-------------------------------
            bool 0 1
            int
            float (32 bit float)
            half (16 bit float)
            fixed (lower precision) -1 to 1
            float4 -> half4 -> fixed
            float4x4 -> half4x4 (C#: Matrix4x4)
---------------------------Data types-------------------------------*/

            fixed4 frag (Interpolators i) : SV_Target{
                
                return float4(1, 0, 0, 1); // red
            }
            ENDCG
        }
    }
}