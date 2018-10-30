import re

#  Script: tcalc.py
# Purpose: Provides an engine to navigate through a json object.
# Created: Aug 26, 2017
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup

class JsonUtils:

    # Construction
    def __init__( self, separator='.', jsonNameRe='[a-zA-Z0-9_\- ]', jsonArrayIndexRe='[0-9]{1,}' ):

        self.separator = separator
        self.jsonNameRe = jsonNameRe
        self.jsonArrayIndexRe = jsonArrayIndexRe


    # find the next element in the list matching the specified value.
    def __findNextElement__( self, rootElement, matchName, matchValue = None, fetchParent=False ):

        selectedElement = rootElement

        if type(selectedElement) is list:

            for nextInList in rootElement:

                if type(nextInList) is dict:

                    selectedElement = nextInList.get(matchName)

                    if selectedElement and ( matchValue is None or ( matchValue and selectedElement == matchValue )):

                        # To return the parent element instead of the leaf
                        if fetchParent:
                            selectedElement = nextInList
                        break

                    else:
                        selectedElement = None

                elif type(nextInList) is unicode:
                    selectedElement = rootElement

                elif type(nextInList) is list:
                    selectedElement = self.__findNextElement__(nextInList, matchName, matchValue)

        elif type(selectedElement) is dict:

            el = selectedElement.get(matchName)

            if el and (matchValue is None or (matchValue and el == matchValue)):

                # To return the parent element instead of the leaf
                if not fetchParent:
                    selectedElement = el

            else:
                selectedElement = None

        else:
            selectedElement = None

        return selectedElement


    # Find the element in the sub-expressions.
    def __findInSubex__(self, subExpressions, subSelectedElement, pat_subExprVal, fetchParent = False):

        for nextSubExpr in subExpressions:

            if nextSubExpr:

                subParts = re.search(pat_subExprVal, nextSubExpr)
                subElemId = subParts.group(1)
                subElemVal = subParts.group(3)
                subSelectedElement = self.__findNextElement__(subSelectedElement, subElemId, subElemVal, fetchParent)

        return subSelectedElement


    # Purpose: Get the json element through it's path. Returned object is either [dict, list or unicode].
    #
    #   Search patterns:
    #     elem1.elem2
    #     elem1.elem2[index]
    #     elem1.elem2{property}
    #     elem1.elem2{property}[index]
    #     elem1.elem2{property<value>}
    #     elem1.elem2[index].elem3
    #     elem1.elem2{property}.elem3
    #     elem1.elem2{property<value>}.elem3
    #     elem1.elem2{property<value>}[index].elem3
    #     elem1.elem2{property<value>}.{property2<value2>}.elem3
    def jsonSelect( self, rootElement, searchPath, fetchParent=False ):

        self.patElem = '%s+' % self.jsonNameRe
        self.patSelElemVal = '(%s)?((\{(%s)(<(%s)>)?\})+)(\[(%s)\])?' % ( self.patElem, self.patElem, self.patElem, self.jsonArrayIndexRe )
        self.patSubExpr = '(\{%s\})' % self.patElem
        self.patSubExprVal = '\{(%s)(<(%s)>)?\}' % (self.patElem, self.patElem)

        selectedElement = rootElement

        try:

            searchTokens = searchPath.split(self.separator)

            for nextElement in searchTokens:

                if nextElement.find('{') >= 0: # Next element has nested elements

                    parts = re.search(self.patSelElemVal, nextElement)
                    selElemId = parts.group(1)
                    subParts = parts.group(2)
                    elemArrayGroup = parts.group(7)
                    elemArrayIndex = parts.group(8)
                    subExpressions = re.compile(self.patSubExpr).split(subParts)

                    if selElemId and type(selectedElement) is dict:
                        selectedElement = selectedElement.get(selElemId)

                    if selectedElement:

                        # Our first element is a list, so we will have to loop and find all the elements and sub expressions in it.
                        if type(selectedElement) is list:

                            for nextInList in selectedElement:

                                subSelectedElement = self.__findInSubex__(subExpressions, nextInList, self.patSubExprVal, fetchParent)

                                # It subSelectedElement is not null then we have found what we wanted.
                                if subSelectedElement:

                                    selectedElement = subSelectedElement
                                    break

                        # Check if there are indexed elements.
                        if elemArrayGroup and elemArrayIndex and type(selectedElement) is list:

                            selectedElement = selectedElement[int(elemArrayIndex)]

                elif nextElement.find('[') >= 0: # Next element is indexed

                    pat_selElemIdx = '(%s)\[(%s)\]' % (self.patElem, self.jsonArrayIndexRe)
                    parts = re.search(pat_selElemIdx, nextElement)
                    subElemId = parts.group(1)
                    elemArrayIndex = parts.group(2)

                    # TODO Implement subarrays like elem[0][1][2]

                    if not subElemId is None and not elemArrayIndex is None:

                        el = selectedElement.get(subElemId)

                        if type(el) is list:
                            selectedElement = el[int(elemArrayIndex)]

                else: # Next element is simple

                    selectedElement = selectedElement.get(nextElement)

        except (AttributeError, IndexError):

            selectedElement = None
            pass

        return selectedElement
