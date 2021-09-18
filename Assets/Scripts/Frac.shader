Shader "Unlit/Frac"{
    Properties{
        _ColorA("Color A", Color) = (1, 1, 1, 1)
        _ColorB("Color B", Color) = (1, 1, 1, 1)
        _ColorStart("Color Start", Range(0,1)) = 0
        _ColorEnd("Color End", Range(0,1)) = 1
    }
    SubShader{
        Tags{ "RenderType"="Opaque" }
        
        Pass{
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"

            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;    
            float _ColorEnd;

            //automatically filled out by Unity
            struct MeshData{ // per-vertex mesh data
                float4 vertex : POSITION; // vertex position
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0; // uv0 diffuse/normal map textures
            };

            struct Interpolators{
                float4 vertex : SV_POSITION; // clip space position
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
                
            };


            Interpolators vert (MeshData v) {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); // local space to clip space
                o.normal = UnityObjectToWorldNormal(v.normals); // just pass through
                o.uv = v.uv0; // pass through
                return o;
            }


            float InverseLerp( float a, float b, float v ){
                return  (v-a)/(b-a);
            }

            
            fixed4 frag (Interpolators i) : SV_Target{

                // blend between two colors based on the X UV coordinate
                float t = InverseLerp( _ColorStart, _ColorEnd, i.uv.x);
                // frac = v - floor(v)

                t = frac(t);
                
                float4 outColor = lerp(_ColorA, _ColorB, t);
                
                return outColor; // red
            }
            ENDCG
        }
    }
}
