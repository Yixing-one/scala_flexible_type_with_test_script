# COMMUNITY_BUILD.SH notes:
#       (1) the main goal is to build several community-build projects to test the performance of scala 3 compiler
#       (2) the name of the community-build projects need to be added to project_list
#       (3) the output of building community-build projects can be found at output/project_name.log
#       (4) output/result_summary.log contain two lists of project names; one for those that are built successfully, and one for those that are not

#include all the community projects that need to be built in the following project_list
project_list=(
        #testA
        "izumiReflect"
        "scalaSTM"
        "Scalatest"
        "scalatestplusTestNG"
        "scissEqual"
        "scissFingerTree"
        "scissLog"
        "scissModel"
        "scissNumbers"
        "scissSerial"
        "scissSerialscissSerialscissSerial"
        "scissSpan"
        "scissLucre"
        "Zio"
        #testB
        "cats"
        "catsEffect3"
        "catsMtl"
        "coop"
        "discipline"
        "disciplineMunit"
        "disciplineSpecs2"
        "fs2"
        "monocle"
        "munit"
        "munitCatsEffect"
        "perspective"
        "scalacheckEffect"
        "scodec"
        "scodecBits"
        "simulacrumScalafixAnnotations"
        "spire"
        "http4s"
        #testC
        "akk"
        "betterfiles"
        "cask"
        "effpi"
        "endpoints4s"
        "fansi"
        "fastparse"
        "geny"
        "intent"
        "jacksonModuleScala"
        "libretto"
        "minitest"
        "onnxScala"
        "oslib"
        "parboiled2"
        "playJson"
        "pprint"
        "protoquill"
        "requests"
        "scalacheck"
        "scalaCollectionCompat"
        "scalaJava8Compat"
        "scalap"
        "scalaParallelCollections"
        "scalaParserCombinators"
        "scalaPB"
        "scalatestplusScalacheck"
        "scalaXml"
        "scalaz"
        "scas"
        "sconfig"
        "shapeless"
        "sourcecode"
        "specs2"
        "stdLib213"
        "ujson"
        "upickle"
        "utest"
        "verify"
        "xmlInterpolator"
       )

#set output to be the name of the directory that project.log and result_summary.log will be stored
output=output_original

#remove the output directory if it already exits and make a new one
rm -r "${output}"
mkdir "${output}"

error=error_no_change
#remove the error directory if it already exits and make a new one
rm -r "${error}"
mkdir "${error}"

#create two array for storing the name of project that fail and success
project_success=()
project_fail=()

#run each project in the project_list; add the project to one of project_success or project_fail base on the exit_status
for project in "${project_list[@]}"
do
    #build the community project
    rm "${output}/${project}.log"
    echo -e "Currently building project: ${project}" 
    echo "sbt \"community-build/testOnly -- *${project}\""
    sbt "community-build/testOnly -- *${project}" &> "${output}/${project}.log"
    if grep -r 'SUCCESS' "${output}/${project}.log"; then
        project_success+=("${project}")
    elif  grep -r 'FAILURE' "${output}/${project}.log"; then
        project_fail+=("${project}")
    else
        echo -e "Cannot run project: ${project}" 
    fi
    sed -n '/[STARTING/,/DONE RUNNING]/p' "${output}/${project}.log" | grep '^\[error' &> "error_no_change/${project}.error"
done

# generate output/result_summary.log which include information in project_success
echo "${#project_success[@]} projects are successfully built:  " >> "${output}/result_summary.log"
for sproject in "${project_success[@]}"
do
    echo -e "\t${sproject}" >> "${output}/result_summary.log"
done

# generate output/result_summary.log which include information in project_fail
echo -e "\n${#project_fail[@]} projects fail to build:  " >> "${output}/result_summary.log"
for fproject in "${project_fail[@]}"
do
    echo -e "\t${fproject}" >> "${output}/result_summary.log"
done

