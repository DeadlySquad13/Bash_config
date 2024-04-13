createModuleThmoon() {
  local componentName=$1;
  local moduleName='thmoon';

  mkdir $componentName;

  tpage --define Component=$componentName \
  $TEMPLATE_PATH/$moduleName/Component.tsx >> \
  $componentName/$componentName.tsx;

  tpage --define Component=$componentName \
  $TEMPLATE_PATH/$moduleName/Component.types.ts >> \
  $componentName/$componentName.types.ts;

  tpage $TEMPLATE_PATH/$moduleName/Component.module.css >> \
  $componentName/$componentName.module.css
}
